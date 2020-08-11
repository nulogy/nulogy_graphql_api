module NulogyGraphqlApi
  module Schema
    class BaseMutation < GraphQL::Schema::Mutation
      def self.visible?(context)
        return true if context[:schema_generation_context?]
        return super && yield if block_given?

        super
      end
    end
  end
end
