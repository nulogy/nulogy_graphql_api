module NulogyGraphqlApi
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/graphql_schema.rake"
    end
  end
end
