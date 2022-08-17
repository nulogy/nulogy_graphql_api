module NulogyGraphqlApi
  module Types
    class PathType < ::GraphQL::Schema::Union
      possible_types NulogyGraphqlApi::Types::PathStringType, NulogyGraphqlApi::Types::PathIntegerType

      def self.resolve_type(object, _context)
        if object.is_a?(PathStringType)
          NulogyGraphqlApi::Types::PathStringType
        else
          NulogyGraphqlApi::Types::PathIntegerType
        end
      end
    end
  end
end