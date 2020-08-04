require "graphql/schema_comparator"
require "rainbow"

class GraphqlSchemaChangesChecker
  def check_changes(old_schema, new_schema)
    compare_result = GraphQL::SchemaComparator.compare(old_schema, new_schema)

    abort "Task aborted!\n #{Rainbow('No schema changes found.').green}" if compare_result.identical?
    abort "Task aborted!" unless accept_breaking_changes?(compare_result)
  end

  private

  def accept_breaking_changes?(compare_result)
    return true if !compare_result.breaking? && compare_result.dangerous_changes.none?

    puts Rainbow("\nThe current GraphQL Schema has breaking or dangerous changes:").yellow

    compare_result.breaking_changes.concat(compare_result.dangerous_changes).each do |change|
      puts Rainbow("\n\n- #{change.message} #{change.dangerous? ? '(Dangerous)' : '(Breaking)'}").yellow
      puts Rainbow("  #{change.criticality.reason}").yellow
    end

    puts "\n\nDo you want to update the schema anyway? [Y/n]"

    STDIN.gets.chomp != "n"
  end
end

class GraphqlSchemaGenerator
  def initialize(schema_output_path, schema_definition_path)
    @schema_output_path = schema_output_path
    @schema_definition_path = schema_definition_path
  end

  def generate_schema
    check_changes
    write_schema_to_file
  end

  private

  def check_changes
    return if old_schema.blank?

    GraphqlSchemaChangesChecker.new.check_changes(old_schema, schema_definition)
  end

  def old_schema
    return unless File.exist?(@schema_output_path)

    File.read(@schema_output_path)
  end

  def schema_definition
    require @schema_definition_path
    GraphQL::Schema.descendants.first.to_definition
  end

  def write_schema_to_file
    File.write(@schema_output_path, schema_definition)
    puts Rainbow("\nSuccessfully updated #{@schema_output_path}").green
  end
end

namespace :nulogy_graphql_api do
  desc "Generate a schema.graphql file"

  task :generate_schema, [:schema_output_path, :schema_definition_path] => :environment do |_task, args|
    abort "schema_definition_path is required" unless args.key?(:schema_definition_path)

    GraphqlSchemaGenerator
      .new(args[:schema_output_path], args[:schema_definition_path])
      .generate_schema
  end
end
