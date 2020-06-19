Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/graphql_api/dummy/test_exception", to: "dummy#test_exception"
  get "/graphql_api/dummy/test_record_not_found", to: "dummy#test_record_not_found"
  get "/graphql_api/dummy/test_unauthorized", to: "dummy#test_unauthorized"
  get "/graphql_api/dummy/test_timeout", to: "dummy#test_timeout"
end
