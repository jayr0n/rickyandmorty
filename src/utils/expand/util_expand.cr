require "http/client"
require "./query_expand"

# Modulo que faz a requisição a API RickAndMorty usando a query_expand

module DoQueryExpand
  @@url = URI.parse("https://rickandmortyapi.com")
  @@client = HTTP::Client.new(@@url)

  private def self.client
    @@client
  end

  def self.get_locations(ids : Array(Int32))
    query = QueryExpand::QUERY_EXPAND
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