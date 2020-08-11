# NulogyGraphqlApi

## Installation

Add this line to your application's Gemfile:

```ruby
gem "nulogy_graphql_api", "0.5.2"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nulogy_graphql_api

## Usage

#### Developing

- [Receiving Requests](#receiving-requests)
- [Error Handling](#error-handling)
- [Types](#types)
  - [UserErrorType](#usererrortype)
  - [UUID](#uuid)
- [Schema Generation](#schema-generation)
- [Node Visibility](#node-visibility)

#### Testing

- [RSpec helpers](#rspec-helpers)
  - [Test helpers](#test-helpers)
  - [Custom matchers](#custom-matchers)


#### Receiving Requests

Given that you have already defined your GraphQL `Schema` you can receive requests by defining a controller action and execute the params by calling the `NulogyGraphqlApi::GraphqlExecutor`. 

 - Remember to configure your routes to include the controller action. 
 - We called the action `execute` in the example below, but you can call it whatever makes more sense for your app.

```ruby
module MyApp
  class GraphqlApiController < ApplicationController
    include NulogyGraphqlApi::ErrorHandling

    def execute
      NulogyGraphqlApi::GraphqlExecutor.execute(
        params, 
        context, 
        Schema, 
        NulogyGraphqlApi::TransactionService.new
      )
    end
  end
end
```

#### Error Handling

The `NulogyGraphqlApi::ErrorHandling` concern rescues from any unhandled `StandardError`. If you need to log errors before the response is sent to the client you can override the `render_error` method.

```ruby
module MyApp
  class GraphqlApiController < ApplicationController
    include NulogyGraphqlApi::ErrorHandling

    def render_error(exception)
      MyApp::ExceptionNotifier.notify(exception)
        
      super
    end
  end
end
```

### Types

#### UserErrorType

This type provides a way of returning end-user errors. You can find more details about this error handling strategy in [this document](https://docs.google.com/document/d/19JBm3gKfn0poxo07fg9rSy5iJ2N9cf3NjuVp0xQnXPQ/edit?usp=sharing).

```ruby
module MyApp
  class CreateEntity < GraphQL::Schema::Mutation
    field :entity, MyApp::EntityType, null: false
    field :errors, [NulogyGraphqlApi::Types::UserErrorType], null: false
    
    def resolve(args)
      entity = create_entity(args)
    
      {
        entity: entity,
        errors: extract_errors(entity)
      }
    end

    def extract_errors(entity)
      entity.errors.map do |attribute, message| 
        {
          path: path_for(attribute),
          message: entity.errors.full_message(attribute, message)
        }
      end
    end
  end
end
```

#### UUID

This type provides a way of returning UUID values.

```ruby
module MyApp
  class EntityType < GraphQL::Schema::Object
    field :id, NulogyGraphqlApi::Types::UUID, null: false
  end
end
```

### Schema Generation

There is a Rake task to generate the `schema.graphql` file. You need to provide the `schema_file_path` and the `schema_definition_path` so that the task can detect breaking changes and generate the file. If you don't have a schema file because it's your first time generating it then the rake task will just create one for you in the path provided.

There is also a third argument `context`. You'll have to configure it to be able to generate the SDL of fields or types that are only visible for more privileged users.

```ruby
namespace :graphql_api do
  desc "Generate the graphql schema of the api."

  task :generate_schema => :environment do
    schema_file_path = MyApp::Engine.root.join("schema.graphql")
    schema_definition_path = MyApp::Engine.root.join("path/to/schema/root/schema.rb")

    NulogyGraphqlApi::Tasks::SchemaGenerator
      .new(schema_file_path, schema_definition_path)
      .generate_schema
  end
end
```

### Node visibility

When you customize the visibility of parts of your graph you have to make sure that node will be visible when the schema is being generated. You can do so by using the `schema_generation_context?` attribute that is added to the context by the `SchemaGenerator` mentioned in the previous section. 

Here is how to use it:

##### On fields
```ruby
field :entity, MyApp::EntityType, null: false do
  description "Find an entity by ID"
  argument :id, ID, required: true

  def visible?(context)
    context[:schema_generation_context?] || context[:current_user].superuser?
  end
end
```


##### On mutations

In this case the `schema_generation_context?` attribute is checked by the BaseMutation class.

```ruby
module MyApp
  class CreateEntity < NulogyGraphqlApi::Schema::BaseMutation
    field :entity, MyApp::EntityType, null: false
    field :errors, [NulogyGraphqlApi::Types::UserErrorType], null: false
    
      def self.visible?(context)
        super { context[:current_user].super_user? }
      end

    def resolve(args)
      # ...
    end
  end
end
```

### RSpec helpers

Add this to your `spec_helpers.rb` file:

```ruby
require "nulogy_graphql_api/rspec"
```

Then you can include helpers and matchers as in:

```ruby
RSpec.configure do |config|
  config.include NulogyGraphqlApi::GraphqlMatchers, graphql: true
  config.include NulogyGraphqlApi::GraphqlHelpers, graphql: true
end
``` 

#### Test helpers

The `execute_graphql` helper execute GraphQL operations directly against the provided schema. This is how it can be used:

```ruby
RSpec.describe MyApp::Graphql::Query, :graphql do
  let(:schema) { MyApp::Schema }

  it "returns an entity" do
    entity = create(:entity)

    response = execute_graphql(<<~GRAPHQL, schema)
      query {
        entity(id: "#{entity.id}") {
          id
        }
      }
    GRAPHQL

    expect(response).to have_graphql_data(
      project: {
        id: entity.id
      }
    )
  end
end
```

The `request_graphql` helper issues a POST request against the provided URL. This is how it can be used:

```ruby
RSpec.describe MyApp::Graphql::Query, :graphql, type: :request do
  it "returns 401 Unauthorized given an unauthenticated request" do
      gql_response = request_graphql(url, <<~GRAPHQL, headers: { "HTTP_AUTHORIZATION" => nil })
        query {
          entities {
            id
          }
        }
      GRAPHQL

      expect(response.status).to eq(401)
      expect(gql_response).to have_graphql_error("Unauthorized")
    end
end
```

#### Custom matchers

These are the custom matchers available:

`have_graphql_data` for checking the response `data`

```ruby
expect(response).to have_graphql_data(
  project: {
    id: entity.id
  }
)
```

`have_graphql_error` for checking the response `errors`

```ruby
expect(response).to have_graphql_error("Error message")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run rubocop and tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nulogy/nulogy_graphql_api/issues. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nulogy/nulogy_graphql_api/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NulogyGraphqlApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nulogy/nulogy_graphql_api/blob/master/CODE_OF_CONDUCT.md).
