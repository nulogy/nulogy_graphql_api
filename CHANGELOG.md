# Change log

## main (unreleased)

_none_

## 5.1.0 (2025-05-29)

**Yanked**

## 5.0.0 (2025-04-23)

**Changes**

* **(Breaking)** Remove `have_graphql_error` RSpec matcher in favour of `have_graphql_errors` RSpec matcher

## 4.3.0 (2024-11-14)

**Changes**

* Test against Rails 8.0

## 4.2.0 (2024-10-28)

* Drop support for Rails 6.1
* Revert change to `have_graphql_data` RSpec matcher

## 4.1.0 (2024-10-25)

* Add support for Rails 7.1
* Improve `have_graphql_data` RSpec matcher
  * Match array values in any order 

## 4.0.0 (2024-05-28)

**Changes**

* Remove the `schema_generation_context?` attribute to the GraphQL `context` when generating the schema. Use the
  already available `GraphQL::Schema::AlwaysVisible` plugin instead.
  * **(Breaking)** Remove the `NulogyGraphqlApi::Schema::BaseMutation` class which introduced a new API for the 
    `visible?` method that took a block. This introduced a deviation from the ruby graphql gem's API only for 
    Mutations and so it was removed. Please ensure that any invocations of `visible?` do not take a block and use
    `GraphQL::Schema::Mutation` instead.
  * **(Breaking)** Change the `NulogyGraphqlApi::Tasks::SchemaGenerator#generate_schema` method to output the 
    stringified version of the schema instead of checking it for changes and writing it to a file.
  * Expose the `#check_changes` and `#write_schema_to_file` methods on the 
    `NulogyGraphqlApi::Tasks::SchemaGenerator` to give the user more control over how to build their
    tooling.
* Allow the user to be specified for the `request_graphql` test helper.

## 3.0.1 (2024-01-30)

* Add `include_graphql_error` RSpec matcher

## 3.0.0 (2024-01-30)

**Changes**
* **(Breaking)** Drop support for Rails 6.0
* **(Breaking)** Drop support for Ruby 2.7

## 2.2.0 (2024-01-15)

**Changes**
* Pin graphql to major version 2. Permit minor version upgrades of graphql
  without forcing the project to release a new version.

## 2.1.3 (2023-12-06)

**Changes**
* Support appraisal 2.5.x
* Support rake 13.1.x
* Support rspec 3.12.x

## 2.1.2 (2023-11-24)

**Changes**
* Support graphql 2.1.x
* Support graphql-schema_comparator 1.2.x

## 2.1.1 (2022-09-21)

**Changes**
* Support Rails 7

## 2.1.0 (2022-02-10)

**Changes**
* Support graphql 2.0.x

## 2.0.1 (2022-01-04)

**Changes**
* Relax graphql-schema-comparator dependency to minor release

## 2.0.0 (2021-11-29)

**Changes**

* **(Breaking)** Bump graphql version from 1.12.5 to 1.13

## 1.1.1 (2021-07-26)

**Changes**
* Bug Fix: Schema generator always errored when generating new schema file 

## 1.1.0 (2021-07-12)

**Changes**

* Support Rails 6.1
* **(Breaking)** Drop support for Rails 5

## 1.0.0 (2021-05-17)

**Changes**

* **(Breaking)** Change argument to `SchemaGenerator`

The `SchemaGenerator` now takes the path to the `schema.graphql` and the schema class as required arguments.
See [the update in the README](README.md#Schema-Generation).

## 0.6.0 (2021-02-24)

**Changes**

* **(Potentially Breaking)** Bump graphql gem version to 1.12.5

## 0.5.3 (2020-08-11)

* Add `BaseMutation`.

## 0.5.1 (2020-08-11)

* Add the `schema_generation_context?` attribute to the GraphQL `context` when generating the schema.

## 0.5.0 (2020-08-05)

**Changes**

* **(Breaking)** Add `context` to the Rake task that generates the schema file.
This changes the way the schema is parsed. Please refer to the README file to see an example of how to use `context`.

## 0.4.0 (2020-07-06)

**Changes**

* **(Breaking)** Remove the GraphqlApiController
* **(Breaking)** Add the ErrorHandling controller concern

## 0.3.1 (2020-07-03)

* Support Rails 6

## 0.3.0 (2020-06-25)

**Changes**

* **(Breaking)** Remove spec helpers related to subscriptions

## 0.2.0 (2020-06-24)

**Changes**

* **(Breaking)** Rename `GraphqlExecutor.call` to `execute`
* **(Breaking)** Change `schema` parameter on `execute_graphql` test helper to positional

## 0.1.1 (2020-06-24)

**Changes**

* RSpec custom matchers
* RSpec helpers

## 0.1.0 (2020-06-05)

* Initial release
