require "rspec/matchers"
require "rspec/expectations"

module NulogyGraphqlApi
  module GraphqlMatchers
    RSpec::Matchers.define :have_graphql_data do |expected_data|
      match do |actual_data|
        # Allow the expected data to be passed without the root :data key.
        @actual = actual_data[:data]
        @expected = expected_data

        deep_match(@expected, @actual)
      end

      diffable

      failure_message do
        "Expected GraphQL data to match (ignoring array ordering) but found differences."
      end

      failure_message_when_negated do
        "Expected GraphQL data not to match (ignoring array ordering) but found no differences."
      end

      def actual
        @actual
      end

      def expected
        @expected
      end

      def deep_match(expected, actual)
        case expected
        when Hash
          return false unless actual.is_a?(Hash) && expected.keys.sort == actual.keys.sort

          expected.all? { |key, value| deep_match(value, actual[key]) }
        when Array
          return false unless actual.is_a?(Array) && expected.size == actual.size

          # Sort both arrays before comparing them element by element.
          expected.sort_by(&:to_s) == actual.sort_by(&:to_s)
        else
          expected == actual
        end
      end
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

  RSpec::Matchers.define :include_graphql_error do |message|
    match do |actual_response|
      expect(actual_response.fetch(:errors, nil)).to include(a_hash_including(
        message: include(message)
      ))
    end
  end
end
