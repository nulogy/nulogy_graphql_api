# Change log

## master (unreleased)

_none_

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
