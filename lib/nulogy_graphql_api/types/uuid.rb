module NulogyGraphqlApi
  module Types
    # "Type" is not included in the name as this is a scalar type
    class UUID < GraphQL::Types::String
      description "A scalar type to represent a UUID. The UUID appears in the JSON response as a string."
    end
  end
end
