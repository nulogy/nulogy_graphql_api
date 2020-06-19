namespace :nulogy_graphql_api do
  desc "Generate a schema.graphql file"

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
    SCHEMA_FILE_NAME = "schema.graphql"

    def generate_schema(old_schema_file_path, new_schema_file_path)
      @old_schema_file_path = old_schema_file_path
      @new_schema_file_path = new_schema_file_path

      generate_schema_file
    end

    private

    def check_changes(old_schema, new_schema)
      GraphqlSchemaChangesChecker.new.check_changes(old_schema, new_schema)
    end

    def new_schema
      require @new_schema_file_path

      GraphQL::Schema.descendants.first.to_definition
    end

    def old_schema
      return nil unless File.exists?(@old_schema_file_path)

      File.read(@old_schema_file_path)
    end

    def generate_schema_file
      check_changes(old_schema, new_schema) if old_schema

      write_new_schema_file
    end

    def write_new_schema_file
      File.write(@old_schema_file_path, new_schema)
      puts Rainbow("\nSuccessfully updated #{@old_schema_file_path}").green
    end
  end

  task :generate_schema, [:old_schema_file_path, :new_schema_file_path] => :environment do |_task, args|
    abort "new_schema_file_path is required" unless args.key?(:new_schema_file_path)

    GraphqlSchemaGenerator.new.generate_schema(args[:old_schema_file_path], args[:new_schema_file_path])
  end
end
