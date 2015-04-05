# rom-roda

Roda plugin for [Ruby Object Mapper](https://github.com/rom-rb/rom).

## Issues

Please report any issues in the main [rom-rb/rom](https://github.com/rom-rb/rom/issues) issue tracker.

## Usage

In your app file, require `rom-roda` and any additional adapter Gems needed to set up your data sources:

```ruby
require 'rom-roda'
require 'rom-sql'
```

### Setup

Embed a ROM environment in your Roda app using the `plugin` hook:

```ruby
class App < Roda
  plugin :rom
end
```

Options passed to the plugin are used to set up one or more adapters, using the [repository args format](http://www.rubydoc.info/gems/rom/ROM/Global#setup-instance_method) supported by `ROM.setup`.

To register a single `sql` repository with an Sqlite data source:

```ruby
class App < Roda
  plugin :rom, :sql, 'sqlite::memory'
end
```

To register a 'default' and a 'warehouse' repository:

```ruby
class App < Roda
  plugin :rom, {
    default: [:sql, 'sqlite::memory'],
    warehouse: [:sql, 'postgres://localhost/warehouse']
  }
end
```

### Loading ROM components

Relations, commands and mappers are automatically registered with the ROM environment when their classes are loaded. This means that these components must be required by the app in a specific order during setup.

You can autoload ROM components from a local path in your app by passing the `:load_path` option to the plugin:

```ruby
class App < Roda
  # register ROM components from './models'
  plugin :rom, :sql, 'sqlite::memory', load_path: 'models'
end
```

In situations where your app is loaded from a path that isn’t the `pwd` of the Rack server process, the ROM plugin plays nicely with Roda’s `opts[:root]` setting:

```ruby
class MyApplication < Roda
  # app file is at './app/my_application.rb'
  opts[:root] = 'app'

  # register ROM components from './app/model'
  plugin :rom, :sql, 'sqlite::memory', load_path: 'model'
end
```

### Using ROM in Roda routes

With the ROM environment configured, the following instance methods are available in Roda routes:

#### rom

Provides an instance of the ROM environment:

```ruby
route do |r|
  rom
end
```

#### relation(name)

Provides an instance of the named relation:

```ruby
route do |r|
  r.on('catalog') do
    @products = relation(:products).in_stock

    r.is('category/:category') do |category|
      @products.by_category(category)
    end
  end
end
```

#### command(name)

Provides an instance of the named command:

```ruby
route do |r|
  r.is('products') do
    r.post do
      command(:products).create.call(r['product'])
    end
  end
end
```

## Community

* [![Gitter chat](https://badges.gitter.im/rom-rb/chat.png)](https://gitter.im/rom-rb/chat)
* [Ruby Object Mapper](https://groups.google.com/forum/#!forum/rom-rb) mailing list

## License

See `LICENSE` file.
