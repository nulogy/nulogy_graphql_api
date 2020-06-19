module NulogyGraphqlApi
  module Types
    class UserErrorType < ::GraphQL::Schema::Object
      description "An end-user readable error"

      field :message, String, null: false,
        description: "A description of the error"
      field :path, [String], null: false,
        description: "Which input value this error came from"
    end
  end
end
