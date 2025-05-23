# NulogyGraphqlApi

## Intent

Help Nulogy applications be compliant with the [Standard on Error-handling in GraphQL](https://trello.com/c/N5cHt4Gp/7-error-handling-in-graphql-apis).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "nulogy_graphql_api", "3.0.1"
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

There is a Rake task to generate the `schema.graphql` file. You need to provide the `schema_file_path` and the schema class so that the task can detect breaking changes and generate the file. If you don't have a schema file because it's your first time generating it then the rake task will just create one for you in the path provided.

```ruby
namespace :graphql_api do
  desc "Generate the graphql schema of the api."

  task :generate_schema => :environment do
    schema_file_path = MyApp::Engine.root.join("schema.graphql")
    schema = MyApp::Namespace::To::Schema

    NulogyGraphqlApi::Tasks::SchemaGenerator
      .new(schema_file_path, schema)
      .write_schema_to_file
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
      gql_response = request_graphql(url, <<~GRAPHQL, headers: { "HTTP_AUTHORIZATION" => nil }, user: default_user)
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

Use `have_graphql_data` for checking the response `data`.

```ruby
expect(response).to have_graphql_data(
  project: {
    id: entity.id
  }
)
```

Use `have_graphql_error` for matching exactly on the response `errors`. <br/>
The match succeeds when the `errors` array contains a single entry with the specified message.

```ruby
expect(response).to have_graphql_error("Error message")
```

Use `include_graphql_error` for matching inclusively on the response `errors`. <br/>
The match succeeds when the `errors` array includes an entry with the specified message.

```ruby
expect(response).to include_graphql_error("Error message")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To test against all supported versions of rails run `bundle exec appraisal install` and then run `bundle exec appraisal rake`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

We treat this project as an internal "open source" project. Everyone at Nulogy is welcome to submit Pull Requests.

### Submitting Pull Requests

The Directly Responsible Individual (DRI) for this project is Daniel Silva.

When you are happy with your changes:

1. Add description of changes to the top of the [CHANGELOG](./CHANGELOG.md) file, under the `master (unreleased)` section subdivided into the following categories:
    - New Features
    - Bug Fixes
    - Changes
        - *prepend these with* **(Breaking)***,* **(Potentially Breaking)** *or just leave it blank in case neither applies*

1. Create a Pull Request.
1. Notify #project-nulogy-graphql-api Slack channel to get the DRI review and merge your changes.

### Merging Pull Requests

Add a comment to the PR with the command `/integrate`. This will trigger the [Integrate](https://github.com/nulogy/nulogy_graphql_api/actions) GitHub action that runs checks (Rubocop, RSpec) and merges the code into the base branch.

### Releasing a new version

1. Take a look at the changes listed under `master (unreleased)` at the top of the [CHANGELOG](./CHANGELOG.md) in order to define the new version according to the rules of [Semantic Versioning](https://semver.org/).


2. Change the `version.rb` file.

    ```ruby
    module NulogyGraphqlApi
        VERSION = "2.1.3"
    end
    ```


3. Add a title to the list of changes with the new version following the format: `X.Y.Z (YYYY-MM-DD)`. Keep the `master (unreleased)` title and add _none_ underneath it. This is how the top of the changelog should look like:

    ```text
    ## master (unreleased)

    _none_
    
    ## 2.1.3 (2023-12-06)
    
    **Changes**
    * Support appraisal 2.5.x
    * Support rake 13.1.x
    * Support rspec 3.12.x
   ```

4. Commit these changes. Suggested commit message: `Release new version`.


5. Go to the [Release](https://github.com/nulogy/nulogy_graphql_api/actions/workflows/gem-push.yml) GitHub action and run a new workflow. The new version will be pushed to [rubygems](https://rubygems.org/gems/nulogy_graphql_api).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NulogyGraphqlApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nulogy/nulogy_graphql_api/blob/master/CODE_OF_CONDUCT.md).

