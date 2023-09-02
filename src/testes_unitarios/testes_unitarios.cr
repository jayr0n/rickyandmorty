require "spec"
require "../utils/expand"
require "../utils/optimize/optimize"

# Teste unitário para o método "expand"

describe "expand_plano_viagem_array" do
  it "returns an array of expanded JSONs" do
    viagens_array : Array(JSON::Any) = [
      JSON.parse(%({"id": 1, "travel_stops": [8, 5, 2, 4, 3]})),
      JSON.parse(%({"id": 4, "travel_stops": [19, 9, 2, 11, 7]}))
    ]

    resultado_esperado = [
      {
        "id" => 1,
        "travel_stops" => [
          {
            "id" => "8",
            "name" => "Post-Apocalyptic Earth",
            "type" => "Planet",
            "dimension" => "Post-Apocalyptic Dimension"
          },
          {
            "id" => "5",
            "name" => "Anatomy Park",
            "type" => "Microverse",
            "dimension" => "Dimension C-137"
          },
          {
            "id" => "2",
            "name" => "Abadango",
            "type" => "Cluster",
            "dimension" => "unknown"
          },
          {
            "id" => "4",
            "name" => "Worldender's lair",
            "type" => "Planet",
            "dimension" => "unknown"
          },
          {
            "id" => "3",
            "name" => "Citadel of Ricks",
            "type" => "Space station",
            "dimension" => "unknown"
          }
        ]
      },
      {
        "id" => 4,
        "travel_stops" => [
          {
            "id" => "19",
            "name" => "Gromflom Prime",
            "type" => "Planet",
            "dimension" => "Replacement Dimension"
          },
          {
            "id" => "9",
            "name" => "Purge Planet",
            "type" => "Planet",
            "dimension" => "Replacement Dimension"
          },
          {
            "id" => "2",
            "name" => "Abadango",
            "type" => "Cluster",
            "dimension" => "unknown"
          },
          {
            "id" => "11",
            "name" => "Bepis 9",
            "type" => "Planet",
            "dimension" => "unknown"
          },
          {
            "id" => "7",
            "name" => "Immortality Field Resort",
            "type" => "Resort",
            "dimension" => "unknown"
          }
        ]
      }
    ]

    expand_plano_viagem_array(viagens_array).should eq(resultado_esperado)
  end
end

# Teste unitário para o método "optimize"

describe DoQueryOptimize do
  describe ".get_locations" do
    it "returns the expected data for the given location ids" do
      ids = [2, 12]
      expected_data = {
        "data" => {
          "locationsByIds" => [
            {
              "id" => "2",
              "name" => "Abadango",
              "dimension" => "unknown",
              "type" => "Cluster",
              "residents" => [
                {
                  "episode" => [
                    {
                      "id" => "27",
                      "name" => "Rest and Ricklaxation"
                    }
                  ],
                  "id" => "6",
                  "name" => "Abadango Cluster Princess"
                }
              ]
            },
            {
              "id" => "12",
              "name" => "Cronenberg Earth",
              "dimension" => "Cronenberg Dimension",
              "type" => "Planet",
              "residents" => [] of Hash(String, String)
            }
          ]
        }
      }

      response = DoQueryOptimize.get_locations(ids)
      response_data = JSON.parse(response)
      response_data.should eq(expected_data)
    end
  end
end




