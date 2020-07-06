class DummyApiController < ActionController::API
  include NulogyGraphqlApi::ErrorHandling

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
