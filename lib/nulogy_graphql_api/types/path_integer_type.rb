module NulogyGraphqlApi
  module Types
    class PathIntegerType < ::GraphQL::Schema::Integer
      description "Represents integer elements in the path array as part of UserErrorType"

      field :path, Integer, null: false
    end
  end
end
