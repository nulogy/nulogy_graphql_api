require "active_record"

module NulogyGraphqlApi
  class TransactionService
    def execute_in_transaction
      context = Transaction.new
      result = nil
      ActiveRecord::Base.transaction(requires_new: true, joinable: false) do
        result = yield(context)
        raise ActiveRecord::Rollback if context.rolledback?
      end
      result
    end

    class Transaction
      def initialize
        @rollback = false
      end

      def rollback
        @rollback = true
      end

      def rolledback?
        @rollback
      end
    end

    # TODO: Move to the spec folder
    class Dummy
      attr_reader :transaction

      def execute_in_transaction
        @transaction = Transaction.new
        @was_called = true
        yield(@transaction)
      end

      def was_called?
        @was_called
      end
    end
  end
end
