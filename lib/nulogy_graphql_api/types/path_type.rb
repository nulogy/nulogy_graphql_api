module NulogyGraphqlApi
  module Types
    class PathType < NulogyGraphqlApi::Types::BaseUnion
      possible_types Integer, String

      # def self.resolve_type(object, _context)
      #   if object.is_a?(PathStringType)
      #     NulogyGraphqlApi::Types::PathStringType
      #   else
      #     NulogyGraphqlApi::Types::PathIntegerType
      #   end
      # end
    end
  end
end
