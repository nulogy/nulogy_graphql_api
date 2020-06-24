RSpec.describe NulogyGraphqlApi::GraphqlExecutor do
  let(:schema) { instance_double("Graphql::Schema") }
  let(:transaction_service) { NulogyGraphqlApi::TransactionService::Dummy.new }
  let(:executor) { described_class.new(schema, transaction_service) }

  it "returns an error when variables cannot be transformed into a JSON object" do
    params = { variables: [] }

    expect {
      executor.execute(params, {})
    }.to raise_error(ArgumentError, /Unexpected parameter: \[\]/)
  end

  describe "transaction handling" do
    it "invokes the transaction service" do
      setup_graphql_response

      executor.execute({}, {})

      expect(transaction_service.was_called?).to be(true)
    end

    it "does not roll back transactions when the GraphQL errors are not present" do
      setup_graphql_response

      executor.execute({}, {})

      expect(transaction_service.transaction.rolledback?).to be(false)
    end

    it "rolls back transactions when there are GraphQL errors" do
      setup_graphql_response_with_graphql_error

      executor.execute({}, {})

      expect(transaction_service.transaction.rolledback?).to be(true)
    end

    it "rolls back transactions where there are domain errors" do
      setup_graphql_response_with_end_user_error

      executor.execute({}, {})

      expect(transaction_service.transaction.rolledback?).to be(true)
    end
  end

  describe "response codes" do
    it "returns a 200 when there are no errors" do
      setup_graphql_response

      response = executor.execute({}, {})

      expect(response[:status]).to eq(200)
    end

    it "returns a 400 when there is a graphql error" do
      setup_graphql_response_with_graphql_error

      response = executor.execute({}, {})

      expect(response[:status]).to eq(400)
    end

    it "returns a 422 when there is a user-facing error to make them easy to identify" do
      setup_graphql_response_with_end_user_error

      response = executor.execute({}, {})

      expect(response[:status]).to eq(422)
    end
  end

  def setup_graphql_response
    expect(schema).to receive(:execute).and_return({})
  end

  def setup_graphql_response_with_end_user_error
    expect(schema).to receive(:execute).and_return("data" => { "payload" => { "errors" => [{}] } })
  end

  def setup_graphql_response_with_graphql_error
    expect(schema).to receive(:execute).and_return("errors" => [{}])
  end
end
