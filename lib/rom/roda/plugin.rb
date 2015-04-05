module ROM
  module Roda
    module Plugin
      def self.configure(app, *args)
        if args.last.is_a?(Hash) && args.last.key?(:load_path)
          load_path = File.expand_path(args.last.delete(:load_path), app.opts[:root])
        end

        ROM.setup(*args)

        self.load_files(load_path) if load_path

        ROM.finalize
      end

      def self.load_files(path)
        Dir["#{path}/**/*.rb"].each do |class_file|
          require class_file
        end
      end

      module InstanceMethods
        def rom
          ROM.env
        end

        def relation(name)
          ROM.env.relation(name)
        end

        def command(name)
          ROM.env.command(name)
        end
      end
    end
  end
end