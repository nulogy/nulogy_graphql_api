module NulogyGraphqlApi
  module GraphqlHelpers
    # Prefer the `request_graphql` method over this one because it exercises more of the stack but doesn't run
    # much slower.
    def execute_graphql(query, schema, variables: {}, context: {})
      camelized_variables = variables.deep_transform_keys! { |key| key.to_s.camelize(:lower) } || {}

      response = schema.execute(
        query,
        variables: camelized_variables,
        context: context,
        operation_name: nil
      )

      response.to_h.deep_symbolize_keys
    end

    def request_graphql(url, query, variables: {}, headers: {}, user: nil)
      params = { query: query, variables: variables }.to_json
      default_headers = {
        CONTENT_TYPE: "application/json",
        HTTP_AUTHORIZATION: basic_auth_token((user || default_user).login)
      }

      post url, params: params, headers: default_headers.merge(headers)

      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
