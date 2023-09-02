require "./util_optimize"
require "json"

# Estrutura para dimensionar e contabilizar a dimensão e popularidade
struct LocationInfo
  property id : String
  property name : String
  property popularity : Int32
  property dimension : String

  def initialize(@id, @name, @popularity, @dimension)
  end
end

# Recebe uma Collection de Travel, fazendo a verificação de todos os Travel dentro que estão no banco
def optimizeCollectionTravelStops(viagens : Granite::Collection(Travel)) # optimize_travel_stops

  resultadosOptimize = [] of JSON::Any

  viagens.each do |viagem|
    travel_stops = viagem.travel_stops.not_nil!

    dados = DoQueryOptimize.get_locations(ids: travel_stops)
    locations = JSON.parse(dados)["data"]["locationsByIds"].as_a

    episode_sums = Hash(String, Int32).new
    dimension_counts = Hash(String, Int32).new

    locations.each do |location|
        dimension = location["dimension"].as_s
        episode_count = location["residents"].as_a.sum { |resident| resident["episode"].as_a.size }

        episode_sums[dimension] = (episode_sums[dimension]? || 0) + episode_count
        dimension_counts[dimension] = (dimension_counts[dimension]? || 0) + 1
    end

    averages = Hash(String, Float64).new
    episode_sums.each do |dimension, sum|
        averages[dimension] = sum.to_f / dimension_counts[dimension]
    end

    location_infos = Array(LocationInfo).new

    locations.each do |location|
        id = location["id"].as_s
        name = location["name"].as_s
        dimension = location["dimension"].as_s
        popularity = location["residents"].as_a.sum { |resident| resident["episode"].as_a.size }

        location_info = LocationInfo.new(id, name, popularity, dimension)
        location_infos << location_info
    end

    sorted_locations = location_infos.sort! do |location1, location2|
        avg1 = averages[location1.dimension].floor.to_i
        avg2 = averages[location2.dimension].floor.to_i
        comp = avg1 <=> avg2
  
        if comp == 0
            comp = location1.dimension <=> location2.dimension
        end
  
        if comp == 0
            comp = location1.popularity <=> location2.popularity
        end
  
        if comp == 0
            comp = location1.name <=> location2.name
        end
  
        comp
    end

    travel_stops = sorted_locations.map { |location| location.id.to_i }
    retorno = { "id" => viagem.id, "travel_stops" => travel_stops }.to_json
    resultadosOptimize << JSON.parse(retorno)
    
    end
    return resultadosOptimize
    end    

def optimizeSingleTravelStops(viagens : Travel) # optimize_travel_stops_unico
  resultadosOptimize = [] of JSON::Any

  travel_stops = viagens.travel_stops.not_nil!
  dados = DoQueryOptimize.get_locations(ids: travel_stops)
  locations = JSON.parse(dados)["data"]["locationsByIds"].as_a

  episode_sums = Hash(String, Int32).new
  dimension_counts = Hash(String, Int32).new

  locations.each do |location|
      dimension = location["dimension"].as_s
      episode_count = location["residents"].as_a.sum { |resident| resident["episode"].as_a.size }

      episode_sums[dimension] = (episode_sums[dimension]? || 0) + episode_count
      dimension_counts[dimension] = (dimension_counts[dimension]? || 0) + 1
  end

  averages = Hash(String, Float64).new
  episode_sums.each do |dimension, sum|
      averages[dimension] = sum.to_f / dimension_counts[dimension]
  end

  location_infos = Array(LocationInfo).new

  locations.each do |location|
      id = location["id"].as_s
      name = location["name"].as_s
      dimension = location["dimension"].as_s
      popularity = location["residents"].as_a.sum { |resident| resident["episode"].as_a.size }

      location_info = LocationInfo.new(id, name, popularity, dimension)
      location_infos << location_info
  end

  sorted_locations = location_infos.sort! do |location1, location2|
      avg1 = averages[location1.dimension].floor.to_i
      avg2 = averages[location2.dimension].floor.to_i
      comp = avg1 <=> avg2

      if comp == 0
          comp = location1.dimension <=> location2.dimension
      end

      if comp == 0
          comp = location1.popularity <=> location2.popularity
      end

      if comp == 0
          comp = location1.name <=> location2.name
      end

      comp
  end

  travel_stops = sorted_locations.map { |location| location.id.to_i }
  retorno = { "id" => viagens.id, "travel_stops" => travel_stops }.to_json
  resultadosOptimize << JSON.parse(retorno)

  return resultadosOptimize
end
