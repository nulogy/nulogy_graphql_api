require "action_controller"

module NulogyGraphqlApi
  class GraphqlExecutor
    attr_reader :schema, :transaction_service

    def self.execute(params, context, schema, transaction_service)
      new(schema, transaction_service).execute(params, context)
    end

    def execute(params, context)
      graphql_response(params, context).render_http_response
    end

    private

    def initialize(schema, transaction_service)
      @schema = schema
      @transaction_service = transaction_service
    end

    def graphql_response(params, context)
      execute_graphql(params, context)
    end

    def execute_graphql(params, context)
      query = params[:query]
      variables = ensure_hash(params[:variables])
      operation_name = params[:operationName]

      transaction_service.execute_in_transaction do |tx|
        result = GraphqlResponse.new(
          schema.execute(
            query,
            variables: variables,
            operation_name: operation_name,
            context: context
          )
        )
        tx.rollback if result.contains_errors?
        result
      end
    end

    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end
end
