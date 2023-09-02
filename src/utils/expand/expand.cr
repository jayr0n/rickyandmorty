# Métodos expand que serão utilizados pelo controller

require "./util_expand"
require "json"

# Função para expandir a viagem pelo Collection da viagem e  converte o ID para inteiro
# Ela só funciona no caso do ID único, e recebe uma Travel como parametro
def expandCollectionTravelPlan(travels : Granite::Collection(Travel)) # expand_plano_viagem
  result = [] of JSON::Any

  travels.each do |travel|
    travel_stops = travel.travel_stops.not_nil!
    doQuery = JSON.parse(DoQueryExpand.get_locations(ids: travel_stops))

    # Crie um mapa de hash que mapeie IDs de localização para seus respectivos objetos de localização
    locations_by_id = doQuery["data"]["locationsByIds"].as_a.each_with_object({} of Int32 => JSON::Any) do |location, hash|
      location_hash = location.as_h
      location_id = location_hash["id"].as_s.to_i # Converte o location_id pra inteiro
      location_hash["id"] = JSON::Any.from_json(location_id.to_json) # Converte o inteiro de volta a um JSON::Any
      hash[location_id] = JSON::Any.new(location_hash)
    end

    # Percorra a matriz travel_stops de entrada e recupere os objetos de localização correspondentes na ordem correta
    ordered_travel_stops = travel_stops.map { |stop_id| locations_by_id[stop_id] }

    travelParser = { "id" => travel.id, "travel_stops" => ordered_travel_stops }.to_json
    result << JSON.parse(travelParser)
  end

  return result
end

def expandArrayTravelPlan(travels_array : Array(JSON::Any)) # expand_plano_viagem_array
  result = [] of JSON::Any

  travels_array.each do |travel|
    travel_stops_json = travel["travel_stops"].as_a
    travel_stops = travel_stops_json.map { |stop| stop.as_i }

    doQuery = JSON.parse(DoQueryExpand.get_locations(ids: travel_stops))

    # Create a hash map that maps location IDs to their respective location objects
    locations_by_id = doQuery["data"]["locationsByIds"].as_a.each_with_object({} of Int32 => JSON::Any) do |location, hash|
      location_hash = location.as_h
      location_id = location_hash["id"].as_s.to_i # Convert the location_id to an integer
      location_hash["id"] = JSON::Any.from_json(location_id.to_json) # Convert the integer back to JSON::Any
      hash[location_id] = JSON::Any.new(location_hash)
    end

    # Iterate through the input travel_stops array and retrieve the corresponding location objects in the correct order
    ordered_travel_stops = travel_stops.map { |stop_id| locations_by_id[stop_id] }

    travelParser = { "id" => travel["id"], "travel_stops" => ordered_travel_stops }.to_json
    result << JSON.parse(travelParser)
  end

  return result
end

# Função para expandir a viagem pelo ID da viagem
# Ela só funciona no caso do ID único, e recebe uma Travel como parametro
def expandSingleTravelPlan(travels : Travel) # expand_plano_viagem_unico
  result = [] of JSON::Any

  doQuery = JSON.parse(DoQueryExpand.get_locations(ids: travels.travel_stops.not_nil!))

  travel_stops = doQuery["data"]["locationsByIds"].as_a.map do |stop|
    new_stop = {} of String => JSON::Any
    stop.as_h.each do |key, value|
      new_stop[key] = key == "id" ? JSON::Any.from_json(value.as_s.to_i.to_json) : value
      end
      new_stop
    end

  travelParser = { "id" => travels.id, "travel_stops" => travel_stops }.to_json
  result << JSON.parse(travelParser)

  return result[0]
end







