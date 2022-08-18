module NulogyGraphqlApi
  module Types
    class UserErrorType < NulogyGraphqlApi::Types::BaseObject
      description "An end-user readable error"

      field :message, String, null: false,
        description: "A description of the error"
      field :path, [NulogyGraphqlApi::Types::PathType], null: false,
        description: "Which input value this error came from"
    end
  end
end
