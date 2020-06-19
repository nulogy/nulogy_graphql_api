class DummyController < ::NulogyGraphqlApi::GraphqlApiController
  def test_record_not_found
    raise ActiveRecord::RecordNotFound
  end

  def test_exception
    raise "Exception message"
  end

  def test_unauthorized
    render_unauthorized
  end

  def test_timeout
    render_timeout
  end
end
