require "graphql/schema_comparator"
require "rainbow"

module NulogyGraphqlApi
  module Tasks
    class SchemaChangesChecker
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

        $stdin.gets.chomp.casecmp("n").zero?
      end
    end
  end
end
