module QueryOptimize
    QUERY_OPTIMIZE = %{
      query LocationsByIds($ids: [ID!]!) {
        locationsByIds(ids: $ids) {
          id
          name
          type
          dimension
          residents {
            episode {
              id
              name
            }
            id
            name
          }
        }
      }
    }
  end