RSpec.describe NulogyGraphqlApi::GraphqlResponse do
  describe "#contains_errors_in_graphql_errors?" do
    it "returns false when the GraphQL errors key is not present" do
      response = NulogyGraphqlApi::GraphqlResponse.new({})

      result = response.contains_errors_in_graphql_errors?

      expect(result).to be(false)
    end

    it "returns false when the GraphQL errors key is nil" do
      response = NulogyGraphqlApi::GraphqlResponse.new("errors" => nil)

      result = response.contains_errors_in_graphql_errors?

      expect(result).to be(false)
    end

    it "returns false when the GraphQL errors key is an empty array" do
      response = NulogyGraphqlApi::GraphqlResponse.new("errors" => [])

      result = response.contains_errors_in_graphql_errors?

      expect(result).to be(false)
    end

    it "returns true when the GraphQL errors key is an array with something in it" do
      response = NulogyGraphqlApi::GraphqlResponse.new("errors" => [{}])

      result = response.contains_errors_in_graphql_errors?

      expect(result).to be(true)
    end
  end

  describe "#contains_errors_in_data_payload?" do
    it "returns false when the data key is not present" do
      response = NulogyGraphqlApi::GraphqlResponse.new({})

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns false when the data key is nil" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => nil)

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns false when the payload key is not present" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => {})

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns false when the payload key is nil" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => { "payload" => nil })

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns false when the user errors key is not present" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => { "payload" => {} })

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns false when the user errors key is nil" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => { "payload" => { "errors" => nil } })

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns false when the user errors key is an empty array" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => { "payload" => { "errors" => [] } })

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end

    it "returns true when the user errors key is an array with something in it" do
      response = NulogyGraphqlApi::GraphqlResponse.new("data" => { "payload" => { "errors" => [{}] } })

      result = response.contains_errors_in_data_payload?

      expect(result).to be(true)
    end

    it "returns true when the second payload has errors" do
      gql_response = {
        "data" => {
          "payload1" => {},
          "payload2" => { "errors" => [{}] }
        }
      }
      response = NulogyGraphqlApi::GraphqlResponse.new(gql_response)

      result = response.contains_errors_in_data_payload?

      expect(result).to be(true)
    end

    it "returns false when the entity at the position of the payload is an array instead of a hash" do
      gql_response = {
        "data" => {
          "listOfEntities" => [{
            "someField" => "someValue"
          }]
        }
      }
      response = NulogyGraphqlApi::GraphqlResponse.new(gql_response)

      result = response.contains_errors_in_data_payload?

      expect(result).to be(false)
    end
  end
end
