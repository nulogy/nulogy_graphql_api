module NulogyGraphqlApi
  module Types
    class PathType < NulogyGraphqlApi::Types::BaseUnion
      possible_types NulogyGraphqlApi::Types::PathIntegerType, NulogyGraphqlApi::Types::PathStringType

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
