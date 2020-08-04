namespace :nulogy_graphql_api do
  desc "Generate a schema.graphql file"

  task :generate_schema, [:schema_output_path, :schema_definition_path] => :environment do |_task, args|
    abort "schema_definition_path is required" unless args.key?(:schema_definition_path)

    GraphqlSchemaGenerator
      .new(args[:schema_output_path], args[:schema_definition_path])
      .generate_schema
  end
end
