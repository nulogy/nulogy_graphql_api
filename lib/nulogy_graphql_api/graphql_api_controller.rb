module NulogyGraphqlApi
  class GraphqlApiController < ActionController::API
    rescue_from StandardError do |exception|
      render_error(exception)
    end

    rescue_from ActiveRecord::RecordNotFound do
      render_not_found
    end

    private

    def show_detailed_error_information?
      Rails.application.config.consider_all_requests_local
    end

    def render_error(exception)
      error = if show_detailed_error_information?
        GraphQLError.new(exception.message, backtrace: exception.backtrace)
      else
        GraphQLError.new("Something went wrong")
      end

      render json: error.render, status: :internal_server_error
    end

    def render_not_found
      render json: GraphQLError.new("Not Found").render, status: :not_found
    end

    def render_unauthorized
      render json: GraphQLError.new("Unauthorized").render, status: :unauthorized
    end

    def render_timeout
      render json: GraphQLError.new("Request Timeout").render, status: :request_timeout
    end
  end

  class GraphQLError
    def initialize(message, backtrace: nil)
      @message = message
      @backtrace = backtrace
    end

    def render
      {
        data: {},
        errors: [{ message: @message }.merge(extensions)]
      }
    end

    def extensions
      if @backtrace
        { extensions: { backtrace: @backtrace } }
      else
        {}
      end
    end
  end
end
