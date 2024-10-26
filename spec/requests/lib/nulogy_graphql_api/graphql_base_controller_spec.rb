# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe DummyBaseController, type: :request do
  it "returns Not Found when requesting an entity that does not exist" do
    get "/graphql_api/dummy_base/test_record_not_found"

    expect(response).to have_http_status(:not_found)
    expect(response_body_json).to have_network_error("Not Found")
  end

  it "returns Request Timeout" do
    get "/graphql_api/dummy_base/test_timeout"

    expect(response).to have_http_status(:request_timeout)
    expect(response_body_json).to have_network_error("Request Timeout")
  end

  it "returns Unauthorized" do
    get "/graphql_api/dummy_base/test_unauthorized"

    expect(response).to have_http_status(:unauthorized)
    expect(response_body_json).to have_network_error("Unauthorized")
  end

  describe "Exception handling" do
    it "returns the exception details including backtrace if an exception occurs" do
      get "/graphql_api/dummy_base/test_exception"

      expect(response).to have_http_status(:internal_server_error)
      expect(response_body_json).to have_network_error(
        "Exception message",
        extensions: include(
          backtrace: a_collection_including(a_string_including("test_exception"))
        )
      )
    end

    context "when the app is configured not to show error details" do
      it "returns a generic message (hides the exception message for security reasons)" do
        consider_all_requests_non_local do
          get "/graphql_api/dummy_base/test_exception"
        end

        expect(response).to have_http_status(:internal_server_error)
        expect(response_body_json).to have_network_error("Something went wrong")
        expect(response_body_first_error_extensions).to_not have_key(:backtrace)
      end
    end
  end

  def response_body_json
    JSON.parse(response.body, symbolize_names: true)
  end

  def response_body_first_error_extensions
    response_body_json[:errors].first.fetch(:extensions, {})
  end

  def consider_all_requests_non_local
    old_val = Rails.application.config.consider_all_requests_local
    Rails.application.config.consider_all_requests_local = false

    yield
  ensure
    Rails.application.config.consider_all_requests_local = old_val
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
