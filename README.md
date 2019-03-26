# Guard::Rspec::Graphiti

`guard-rspec-graphiti` is a utility gem for extending the DSL provided by [`guard-rspec`](https://github.com/guard/guard-rspec) to support the new app concepts and test types provided by [Graphiti](https://github.com/graphiti-api/graphiti).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'guard-rspec-graphiti', groups: [:development]
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-rspec-graphiti

## Usage

### Standard Setup

This gem is designed to be used to extend the default guard-rspec template so that changes to your models and
Graphiti resources will trigger the appropriate resource and API specs. Given a guard-rspec configuration
block:

```ruby
guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
  # ...
  # remaining setup
  #
end
```

We need to require the graphiti dsl setup the default watchers:

```ruby
guard :rspec, cmd: "bundle exec rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # Add everything below this somewhere in your `guard :rspec` block
  require 'guard/rspec/graphiti/dsl'
  graphiti = Guard::RSpec::Graphiti::Dsl.new(self, dsl)

  graphiti.watch_resources
  graphiti.watch_models
end
```

And that's it! Now whenever you change `app/models/post.rb`, the specs in
`spec/resources/post` and `spec/api/posts` will automatically run.

### Custom Watchers

If you have a non-standard setup or wish to add some additional control and watchers, you the dsl also
exposes some lower-level items to allow you to compose your setup a bit more granularly:

- `graphiti.resources`: A regex to match `app/resources`, with a match group for the resource name
- `graphiti.resource_specs`: The path to the spec directory for resource specs. Accepts an optional
  parameter of the resource name, which will only return the directory for the specific resource
- `graphiti.api_specs`: The path to the spec directory for e2e API specs. Accepts an optional
  parameter of the resource name, which will only return the directory for the specific API specs
  for that resource.  Like graphiti, this will default to `specs/api/v1` as the root directory, but
  if the project has a `.graphiticfg.yml`, it will attempt to replace this with the `namespace`
  configuration option.

## Development

Bug reports and pull requests are welcome on GitHub at https://github.com/graphiti-api/guard-rspec-graphiti.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
