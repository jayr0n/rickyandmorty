Amber::Server.configure do

  pipeline :api do
    # plug Amber::Pipe::PoweredByAmber.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::CORS.new
  end

  routes :api do

    # 1. Criação de um novo plano de viagem
    route "POST", "/travel_plans", TravelController, :createTravelStops
    
    # 2. Obtenção de todos os planos de viagem
    route "GET", "/travel_plans", TravelController, :getAllTravelStops

    # 3. Obtenção de um plano de viagem específico
    route "GET", "/travel_plans/:id", TravelController, :getTravelStopsByID

    # 4. Atualização de um plano de viagem existente
    route "PUT", "/travel_plans/:id", TravelController, :updateTravelStopsByID

    # 5. Exclusão de um plano de viagem existente
    route "DELETE", "/travel_plans/:id", TravelController, :deleteTravelStops

    # 6. (Adicional) Adiciona uma nova parada a um travel_stops pelo id
    route "PUT", "/travel_plans/:id/append", TravelController, :appendNewTravelStop
  end

end
