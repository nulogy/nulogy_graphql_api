module NulogyGraphqlApi
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
