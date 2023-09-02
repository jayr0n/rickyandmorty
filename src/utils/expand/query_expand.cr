module QueryExpand
    QUERY_EXPAND = %{
      query LocationsByIds($ids: [ID!]!) {
        locationsByIds(ids: $ids) {
          id
          name
          type
          dimension
        }
      }
    }
  end