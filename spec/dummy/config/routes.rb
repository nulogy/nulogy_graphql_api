Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/graphql_api/dummy_api/test_exception", to: "dummy_api#test_exception"
  get "/graphql_api/dummy_api/test_record_not_found", to: "dummy_api#test_record_not_found"
  get "/graphql_api/dummy_api/test_timeout", to: "dummy_api#test_timeout"
  get "/graphql_api/dummy_api/test_unauthorized", to: "dummy_api#test_unauthorized"

  get "/graphql_api/dummy_base/test_exception", to: "dummy_base#test_exception"
  get "/graphql_api/dummy_base/test_record_not_found", to: "dummy_base#test_record_not_found"
  get "/graphql_api/dummy_base/test_timeout", to: "dummy_base#test_timeout"
  get "/graphql_api/dummy_base/test_unauthorized", to: "dummy_base#test_unauthorized"

  post "/graphql_api/dummy_api/graphql", to: "dummy_api#execute"
end
