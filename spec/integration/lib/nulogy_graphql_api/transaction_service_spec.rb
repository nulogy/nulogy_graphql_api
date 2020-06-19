RSpec.describe NulogyGraphqlApi::TransactionService do
  before do
    define_table("db_class", { attr: :string }, true)
  end

  let(:service) { described_class.new }
  let(:db_class) { define_ar("db_class") }

  it "executes work" do
    object = create_object

    service.execute_in_transaction do
      object.update(attr: "new attr")
    end

    expect(object.reload.attr).to eq("new attr")
  end

  it "rolls back the work when there is an exception" do
    object = create_object(attr: "old attr", id: 1)

    expect {
      service.execute_in_transaction do
        object.update(attr: "new attr")
        raise "exception!"
      end
    }.to raise_error("exception!")

    expect(object.reload.attr).to eq("old attr")
  end

  it "rolls back the work when the rollback_when proc is true" do
    object = create_object(attr: "old attr", id: 2)

    service.execute_in_transaction do |tx|
      object.update(attr: "new attr")
      tx.rollback
    end

    expect(object.reload.attr).to eq("old attr")
  end

  it "returns the return value of the block even when there is a rollback" do
    result = service.execute_in_transaction do |tx|
      tx.rollback
      "return value"
    end

    expect(result).to eq("return value")
  end

  def create_object(args = {})
    db_class.create(args)
  end
end
