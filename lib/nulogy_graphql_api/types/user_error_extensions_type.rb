module NulogyGraphqlApi
  module Types
    class UserErrorExtensionsType < ::GraphQL::Schema::Object
      description "Additional information about the error"

      field :short_message, String, null: true,
        description: "A short description of the error"
    end
  end
end
