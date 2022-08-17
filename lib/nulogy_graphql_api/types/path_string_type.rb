module NulogyGraphqlApi
  module Types
    class PathStringType < ::GraphQL::Schema::String
      description "Represents string elements in the path array as part of UserErrorType"

      field :path, String, null: false
    end
  end
end