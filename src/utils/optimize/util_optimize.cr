require "http/client"
require "./query_optimize"

module DoQueryOptimize
  @@url = URI.parse("https://rickandmortyapi.com")
  @@client = HTTP::Client.new(@@url)

  private def self.client
    @@client
  end

  def self.get_locations(ids : Array(Int32))
    query = QueryOptimize::QUERY_OPTIMIZE
    headers = HTTP::Headers{"Content-Type" => "application/json"}
    body = {
      query:         query,
      operationName: "LocationsByIds",
      variables:     {
        ids: ids,
      },
    }.to_json

    response = client.post("/graphql", headers, body)
    return response.body
  end
end