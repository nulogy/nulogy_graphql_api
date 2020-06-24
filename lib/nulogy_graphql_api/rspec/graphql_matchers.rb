require "rspec/matchers"
require "rspec/expectations"

module NulogyGraphqlApi
  module GraphqlMatchers
    RSpec::Matchers.define :have_graphql_data do |expected_data|
      match do |graphql_response|
        @expected_response = { data: expected_data }
        expect(graphql_response).to match(@expected_response)
      end

      failure_message do |actual_response|
        <<~MSG
          expected: #{@expected_response.pretty_inspect}

          got: #{actual_response.pretty_inspect}
        MSG
      end
    end

    RSpec::Matchers.define :have_graphql_error do |message|
      match do |actual_response|
        expect(actual_response.fetch(:errors, nil)).to contain_exactly(a_hash_including(
          message: include(message)
        ))
      end
    end

    RSpec::Matchers.define :have_network_error do |message, error_extensions = {}|
      match do |actual_response|
        expect(actual_response).to match({
          data: {},
          errors: [{ message: message }.merge(error_extensions)]
        })
      end
    end
  end
end
