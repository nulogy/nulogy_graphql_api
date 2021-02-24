class DummyApiController < ActionController::API
  include NulogyGraphqlApi::ErrorHandling

  def execute
    result = NulogyGraphqlApi::GraphqlExecutor.execute(params, {}, ::FakeSchema, NulogyGraphqlApi::TransactionService.new)

    render json: result[:json], status: result[:status]
  end

  def test_exception
    raise "Exception message"
  end

  def test_record_not_found
    raise ActiveRecord::RecordNotFound
  end

  def test_timeout
    render_timeout
  end

  def test_unauthorized
    render_unauthorized
  end
end
