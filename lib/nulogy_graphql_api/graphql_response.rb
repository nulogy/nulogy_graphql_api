module NulogyGraphqlApi
  # This class provides a wrapper around the hash returned by GraphQL::Schema#execute.
  #
  # The hash is assumed to have String keys rather than Symbol keys because that is what
  # the Graphql-ruby gem outputs.
  class GraphqlResponse
    def initialize(graphql_response_json)
      @graphql_response_json = graphql_response_json
    end

    # Detects errors embedded in the GraphQL schema (intended to be shown to end-users):
    # {
    #   "data": {
    #     "somePayload": {
    #       "errors": [{
    #         "message": "Something went wrong!"
    #       }]
    #     }
    #   }
    # }
    def contains_errors_in_data_payload?
      if @graphql_response_json["data"].present?
        @graphql_response_json["data"].values.any? do |payload|
          payload.is_a?(Hash) ? payload["errors"].present? : false
        end
      else
        false
      end
    end

    # Detects errors in the standard GraphQL error list (intended to be shown to developers and API clients):
    # {
    #   "errors": [{
    #     "message": "Something went wrong!"
    #   }]
    # }
    def contains_errors_in_graphql_errors?
      @graphql_response_json["errors"].present?
    end

    def contains_errors?
      contains_errors_in_graphql_errors? || contains_errors_in_data_payload?
    end

    def http_response_code
      if contains_errors_in_graphql_errors?
        400
      elsif contains_errors_in_data_payload?
        # mimic Rails behaviour when there are validation errors. Also enable clients to easily
        # identify user-facing errors. CPI for instance will retry these to deal with race
        # conditions.
        422
      else
        200
      end
    end

    def render_http_response
      {
        json: @graphql_response_json,
        status: http_response_code
      }
    end
  end
end
