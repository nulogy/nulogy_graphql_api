# Change log

## master (unreleased)

## 0.5.0

**Breaking Changes**

* Add `context` to the Rake task that generates the schema file.  
This changes the way the schema is parsed. Please refer to the README file to see an example of how to use `context`.

## 0.4.0 (2020-07-06)

**Breaking Changes**

* Remove the GraphqlApiController
* Add the ErrorHandling controller concern

## 0.3.1 (2020-07-03)

* Support Rails 6

## 0.3.0 (2020-06-25)

**Breaking Changes**

* Remove spec helpers related to subscriptions

## 0.2.0 (2020-06-24)

**Breaking Changes**

* Rename `GraphqlExecutor.call` to `execute`
* Change `schema` parameter on `execute_graphql` test helper to positional

## 0.1.1 (2020-06-24)

**New Features**

* RSpec custom matchers
* RSpec helpers

## 0.1.0 (2020-06-05)

* Initial release
