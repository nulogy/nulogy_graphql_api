class VisibleQuery < GraphQL::Schema::Object
  field :test, String, null: false
end

class InvisibleQuery < GraphQL::Schema::Object
  field :test, String, null: false

  def self.visible?(_context)
    false
  end
end

RSpec.describe NulogyGraphqlApi::Tasks::SchemaGenerator do
  it "stringifies the schema" do
    fake_schema = Class.new(GraphQL::Schema) do
      query VisibleQuery
    end
    task = NulogyGraphqlApi::Tasks::SchemaGenerator.new("schema_output_path", fake_schema)

    result = task.generate_schema

    expect(result).to eq(<<~GQL)
      schema {
        query: VisibleQuery
      }

      type VisibleQuery {
        test: String!
      }
    GQL
  end

  it "stringifies invisible parts of the schema" do
    fake_schema = Class.new(GraphQL::Schema) do
      query InvisibleQuery
    end
    task = NulogyGraphqlApi::Tasks::SchemaGenerator.new("schema_output_path", fake_schema)

    result = task.generate_schema

    expect(result).to eq(<<~GQL)
      schema {
        query: InvisibleQuery
      }

      type InvisibleQuery {
        test: String!
      }
    GQL
  end

  it "does not alter the given schema" do
    fake_schema = Class.new(GraphQL::Schema)
    old_warden = fake_schema.warden_class
    task = NulogyGraphqlApi::Tasks::SchemaGenerator.new("schema_output_path", fake_schema)

    task.generate_schema

    expect(fake_schema.warden_class).to eq(old_warden)
  end
end
