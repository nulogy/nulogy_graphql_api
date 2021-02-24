class FakeQuery < GraphQL::Schema::Object
  extend ActiveSupport::Concern

  field :fakes, [FakeType], null: false

  def fakes
    [
      { field: "foo" },
      { field: "bar" }
    ]
  end
end
