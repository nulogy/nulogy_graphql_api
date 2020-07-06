require "nulogy_graphql_api/graphql_error"

module NulogyGraphqlApi
  module ErrorHandling
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |exception|
        render_error(exception)
      end

      rescue_from ActiveRecord::RecordNotFound do
        render_not_found
      end
    end

    private

    def show_detailed_error_information?
      Rails.application.config.consider_all_requests_local
    end

    def render_error(exception)
      error = if show_detailed_error_information?
        NulogyGraphqlApi::GraphQLError.new(exception.message, backtrace: exception.backtrace)
      else
        NulogyGraphqlApi::GraphQLError.new("Something went wrong")
      end

      render json: error.render, status: :internal_server_error
    end

    def render_not_found
      render json: NulogyGraphqlApi::GraphQLError.new("Not Found").render, status: :not_found
    end

    def render_unauthorized
      render json: NulogyGraphqlApi::GraphQLError.new("Unauthorized").render, status: :unauthorized
    end

    def render_timeout
      render json: NulogyGraphqlApi::GraphQLError.new("Request Timeout").render, status: :request_timeout
    end
  end
end
