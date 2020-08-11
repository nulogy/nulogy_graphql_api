module NulogyGraphqlApi
  module Tasks
    class SchemaGenerator
      def initialize(schema_output_path, schema_definition_path, context: {})
        @schema_output_path = schema_output_path
        @schema_definition_path = schema_definition_path
        @context = context.merge(
          schema_generation_context?: true
        )
      end

      def generate_schema
        check_changes
        write_schema_to_file
      end

      private

      def check_changes
        return if old_schema.blank?

        SchemaChangesChecker.new.check_changes(old_schema, schema_definition)
      end

      def old_schema
        return unless File.exist?(@schema_output_path)

        File.read(@schema_output_path)
      end

      def schema_definition
        require @schema_definition_path
        @schema_definition ||= GraphQL::Schema.descendants.first.to_definition(context: @context)
      end

      def write_schema_to_file
        File.write(@schema_output_path, schema_definition)
        puts Rainbow("\nSuccessfully updated #{@schema_output_path}").green
      end
    end
  end
end
