class Travel < Granite::Base
  connection pg
  table travels

  column id : Int64, primary: true
  column travel_stops : Array(Int32)?
end
