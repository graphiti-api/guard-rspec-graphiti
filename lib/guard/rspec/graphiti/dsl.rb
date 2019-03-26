require_relative '../graphiti'

module Guard
  class RSpec < Plugin
    module Graphiti
      class Dsl
        def initialize(guard, rspec_dsl)
          @guard_dsl = guard
          @rspec_dsl = rspec_dsl
        end

        def watch_resources
          @guard_dsl.send(:watch, resources) do |m|
            [
              api_specs(m[1]),
              resource_specs(m[1])
            ]
          end
        end

        def watch_models
          @guard_dsl.send(:watch, %r{^app/models/(.+)\.rb$}) do |m|
            [
              api_specs(m[1]),
              resource_specs(m[1])
            ]
          end
        end

        def resources
          %r{^app/resources/(.+)_resource\.rb$}
        end

        def resource_specs(resource_name = nil)
          resource_base = "#{rspec.spec_dir}/resources"

          if resource_name
            "#{resource_base}/#{resource_name.underscore}"
          else
            resource_base
          end
        end

        def api_specs(resource_name = nil)
          api_base = "#{rspec.spec_dir}#{api_namespace}"

          if resource_name
            "#{api_base}/#{resource_name.underscore.pluralize}"
          else
            api_base
          end
        end

        private

        def rspec
          @rspec_dsl.rspec
        end

        def api_namespace
          graphiti_config['namespace'] || '/api/v1'
        end

        def graphiti_config
          @graphiti_config ||= File.exist?(".graphiticfg.yml") ? YAML.load_file(".graphiticfg.yml") : {}
        end
      end
    end
  end
end