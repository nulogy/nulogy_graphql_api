module NulogyGraphqlApi
  module Types
    class PathType < NulogyGraphqlApi::Types::BaseUnion
      possible_types PathIntegerType, PathStringType

      def self.resolve_type(object, _context)
        p '*' * 80
        p object
        p object.is_a?(PathStringType)
        p object.class

        if object.is_a?(NulogyGraphqlApi::Types::PathStringType)
          NulogyGraphqlApi::Types::PathStringType
        else
          NulogyGraphqlApi::Types::PathIntegerType
        end
      end
    end
  end
end
