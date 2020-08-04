module NulogyGraphqlApi
  module Tasks
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
  end
end