# relative-require all rspec files
Dir[File.dirname(__FILE__) + "/rspec/*.rb"].each do |file|
  require "nulogy_graphql_api/rspec/" + File.basename(file, File.extname(file))
end
