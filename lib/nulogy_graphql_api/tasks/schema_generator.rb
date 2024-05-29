module NulogyGraphqlApi
  module Tasks
    class SchemaGenerator
      def initialize(schema_output_path, schema, context: {})
        @schema_output_path = schema_output_path
        @schema = schema
        @context = context
      end

      def generate_schema
        visible_schema = Class.new(@schema)
        visible_schema.use(GraphQL::Schema::AlwaysVisible)
        visible_schema.to_definition(context: @context)
      end

      def check_changes
        return if old_schema.blank?

        SchemaChangesChecker.new.check_changes(old_schema, generate_schema)
      end

      def write_schema_to_file
        File.write(@schema_output_path, generate_schema)
        puts Rainbow("\nSuccessfully updated #{@schema_output_path}").green
      end

      private

      def old_schema
        return unless File.exist?(@schema_output_path)

        File.read(@schema_output_path)
      end
    end
  end
end
