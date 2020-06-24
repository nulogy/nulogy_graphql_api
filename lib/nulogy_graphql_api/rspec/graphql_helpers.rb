module NulogyGraphqlApi
  module GraphqlHelpers
    def execute_graphql(query, schema, variables: {}, context: default_graphql_context)
      camelized_variables = variables.deep_transform_keys! { |key| key.to_s.camelize(:lower) } || {}

      response = schema.execute(
        query,
        variables: camelized_variables,
        context: context,
        operation_name: nil
      )

      response.to_h.deep_symbolize_keys
    end

    def default_graphql_context
      {
        site_id: default_site.id,
        account_id: default_account.id,
        current_user: default_user
      }
    end

    def request_graphql(url, query, variables: {}, headers: {})
      params = { query: query, variables: variables }.to_json
      default_headers = {
        "CONTENT_TYPE": "application/json",
        "HTTP_AUTHORIZATION": basic_auth_token(default_user.login)
      }

      post url, params: params, headers: default_headers.merge(headers)

      JSON.parse(response.body, symbolize_names: true)
    end

    def find_subscription_event!(subscription)
      events = GraphqlApi::Models::PublicSubscriptionEvent.where(public_subscription_id: subscription.id)
      expect(events.count).to eq(1)
      events.first
    end

    def subscribe_to(schema, subscription_name, query)
      subscription_id = SecureRandom.uuid
      subscription_group_id = SecureRandom.uuid
      topic_name = "some_topic"

      gql = <<~GRAPHQL
        subscription {
          #{subscription_name} (
            subscriptionId: "#{subscription_id}",
            subscriptionGroupId: "#{subscription_group_id}",
            topicName: "#{topic_name}"
          ) {
            #{query}
          }
        }
      GRAPHQL

      expect do
        gql_response = execute_graphql(gql, schema)
        expect(gql_response).to eq(data: {})
      end.to change(GraphqlApi::Models::PublicSubscription, :count).by(1)

      GraphqlApi::Models::PublicSubscription.find(subscription_id)
    end
  end
end
