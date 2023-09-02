require "../utils/optimize/optimize"
require "../utils/expand/expand"
require "json"

class TravelController < ApplicationController

  # 1 - Controller criação do travel_stops
  # Exemplo de chamada: http POST http://localhost:3000/viagens
  # Corpo da chamada: "travel_stops": [1,2,3,4,5,6,7,8,9,10] 
  # Corpo da resposta: {"id":1,"travel_stops":[1,2,3,4,5,6,7,8,9,10]}

   def createTravelStops

    travel_plan = Travel.new(travel_stops: JSON.parse(travel_params.validate!["travel_stops"].not_nil!).as_a.map(&.as_i))

    if travel_plan.save
      json_response = {"id" => travel_plan.id,"travel_stops" => travel_plan.travel_stops}

      respond_with 201 do
        json json_response.to_json
      end

    else
      respond_with 422 do
        json travel_plan.errors.to_json
      end
    end

  end

# 2 - Controller retorno todos travel_stops
# Exemplo de chamada: http GET http://localhost:3000/viagens
# Corpo da resposta: 
#[{"id":1,"travel_stops":[1,2,3,4,5,6,7,8,9,10]},{"id":2,"travel_stops":[1,2,3,4,5,6,7,8,9,10]}]
# Parametros da chamada: expand e optimize
# Exemplo de chamada: http GET http://localhost:3000/viagens?expand=true&optimize=true

  def getAllTravelStops

    travels = Travel.all

    expand = params["expand"]? == "true"
    optimize = params["optimize"]? == "true"

    if expand && optimize
      jsonOptimize = optimizeCollectionTravelStops(travels)

      resultExpandOptimize = expandArrayTravelPlan(jsonOptimize)

      respond_with 200 do 
        json resultExpandOptimize.to_json
      end

    elsif expand
      resultExpand = expandCollectionTravelPlan(travels)

      respond_with 200 do
        json resultExpand.to_json
      end

    elsif optimize
      resultOptimize = optimizeCollectionTravelStops(travels)

      respond_with 200 do
        json resultOptimize.to_json
      end

    else 
      respond_with 200 do 
        json travels.to_json
      end

  end
  end

# 3 - Controller retorno travel_stops por ID
# Exemplo de chamada: http GET http://localhost:3000/viagens/1
# Corpo da resposta: {"id":1,"travel_stops":[1,2,3,4,5,6,7,8,9,10]}
# Parametros da chamada: expand e optimize
# Exemplo de chamada: http GET http://localhost:3000/viagens/1?expand=true&optimize=true

  def getTravelStopsByID

    if travels = Travel.find params["id"]

      expand = params["expand"]? == "true"
      optimize = params["optimize"]? == "true"

      if expand && optimize
        jsonOptimize = optimizeSingleTravelStops(travels)

        resultExpandOptimize = expandArrayTravelPlan(jsonOptimize)

        respond_with 200 do 
          json resultExpandOptimize[0].to_json
        end

      elsif expand
        resultExpand = expandSingleTravelPlan(travels)

       respond_with 200 do 
        json resultExpand.to_json
       end

      elsif optimize
        resultOptimize = optimizeSingleTravelStops(travels)

        respond_with 200 do
          json resultOptimize[0].to_json
        end

      else 
        respond_with 200 do
          json travels.to_json
      end
      end

    end
  end

# 4 - Controller atualiza travel_stops por ID
# Exemplo de chamada: http PUT http://localhost:3000/viagens/1
# Corpo da chamada: "travel_stops": [1,2,3,4,5,6,7,8,9,10]
# Corpo da resposta: {"id":1,"travel_stops":[1,2,3,4,5,6,7,8,9,10]}

  def updateTravelStopsByID

    if travels = Travel.find(params["id"])

      travel_plan = Travel.new(travel_stops: JSON.parse(travel_params.validate!["travel_stops"].not_nil!).as_a.map(&.as_i))

      travels.travel_stops = travel_plan.travel_stops

      if travels.valid? && travels.save
        respond_with 200 do
          json travels.to_json
        end

      else
        results = {status: "invalid"}

        respond_with 422 do
          json results.to_json
        end
      end

    else
      results = {status: "not found"}

      respond_with 404 do
        json results.to_json
      end
    end

  end

# 5 - Controller excluir travel_stops por ID
# Exemplo de chamada: http DELETE http://localhost:3000/viagens/1

  def deleteTravelStops

    if travel = Travel.find params["id"]
      travel.destroy
      respond_with 204 do
        json ""
      end

    else
      results = {status: "not found"}
      respond_with 404 do
        json results.to_json
      end
    end
    
  end

# 6 - Controller append novo travel_stops por ID
# Exemplo de chamada: http PUT http://localhost:3000/viagens/{id}/append
# Adiciona uma parada ao travel_stop caso ela não exista

  def appendNewTravelStop
    if travels = Travel.find(params["id"])

      new_travel_stop = travel_params.validate!["travel_stops"].not_nil!.to_i

      added = false

      travels.travel_stops.try &.not_nil!.try do |travel_stops|
        unless travel_stops.includes?(new_travel_stop)
          travel_stops << new_travel_stop
          added = true
        end
      end

      if added
        if travels.valid? && travels.save
          respond_with 200 do
            json travels.to_json
          end
        else
          results = {status: "invalid"}
          respond_with 422 do
            json results.to_json
          end
        end
      else
        results = {status: "travel_stop already exists"}
        respond_with 400 do
          json results.to_json
        end
      end
    else
      results = {status: "not found"}
      respond_with 404 do
        json results.to_json
      end
    end
  end

def travel_params
  params.validation do
    required :travel_stops
  end
end

end
