module ROM
  module Roda
    module Plugin
      class << self
        attr_reader :environments

        def configure(app, config)
          load_paths = [*(config.delete(:load_path) || config.delete(:load_paths))].map do |path|
            File.expand_path(
              path,
              app.opts[:root]
            )
          end if config[:load_path] || config[:load_paths]

          @environments = config.each_with_object({}) do |(env_name, env_config), container|
            container[env_name] = ROM::Environment.new.tap do |env|
              env.setup(*[env_config.fetch(:setup)].flatten)

              env_config.fetch(:plugins, {}).each do |*args|
                env.use(*args.flatten)
              end
            end
          end

          load_paths.map { |path| load_files(path) } if load_paths
        end

        def load_files(path)
          Dir["#{path}/**/*.rb"].each do |class_file|
            require class_file
          end
        end
      end

      module ClassMethods
        def freeze
          @__rom__ = ROM::Roda::Plugin.environments.each_with_object({}) do |(name, env), container|
            container[name] = env.finalize.container
          end

          super
        end

        def rom(environment = nil)
          environment = :default if environment.nil?
          @__rom__.fetch(environment)
        end
      end

      module InstanceMethods
        def rom(environment = nil)
          self.class.rom(environment)
        end

        def relation(name, environment = nil)
          rom(environment).relation(name)
        end

        def command(name, environment = nil)
          rom(environment).command(name)
        end
      end
    end
  end
end
