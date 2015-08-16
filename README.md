# rom-roda

Roda plugin for [Ruby Object Mapper](https://github.com/rom-rb/rom).

## Issues

Please report any issues in the [issue tracker](https://github.com/rom-rb/rom-roda/issues/new).

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
  plugin :rom, {
    default: {
      setup: :memory
    },
    plugins: [:auto_registration]
  }
end
```

Options passed to the environment under the `:setup` key are used to set up one or more adapters, using the [repository args format](http://www.rubydoc.info/gems/rom/ROM/Global#setup-instance_method) supported by `ROM.setup`.

Plugins passed to the environment under the `:plugins` key will be applied to the environment. 

To register a single `sql` repository with an Sqlite data source and use the `auto_registration` environment plugin:

```ruby
class App < Roda
  plugin :rom, {
    default: {
      setup: [:sql, 'sqlite::memory'],
      plugins: [:auto_registration]
    }
  }
end
```

To register a 'default' and a 'warehouse' repository:

```ruby
class App < Roda
  plugin :rom, {
    default: {
      setup: {
        default: [:sql, 'sqlite::memory'],
        warehouse: [:sql, 'postgres://localhost/warehouse']
      }
    }
  }
end
```

You can also register multiple ROM environments, when doing so, it can be useful to pass configuration options to environment plugins, the following example will register items defined in the `Web` namespace with the `memory` environment and items defined in the `API` namespace with the `sql` environment:

```ruby
class App < Roda
  plugin :rom, {
    memory: {
      setup: :memory,
      plugins: {
        auto_registration: {
          if: ->(item) { item.to_s[/(.*)(?=::)/] == 'Web' }
        }
      }
    },
    sql: {
      setup: [:sql, 'sqlite::memory'],
      plugins: {
        auto_registration: {
          if: ->(item) { item.to_s[/(.*)(?=::)/] == 'API' }
        }
      }
    }
  }
end
```

### Loading ROM components

Relations, commands and mappers need to be registered with the ROM environment before the environment is finalized (this can also be done via the `auto_registration` plugin). This means that these components must be required by the app in a specific order during setup.

You can autoload ROM components from a local path in your app by passing the `:load_path` option to the plugin:

```ruby
class App < Roda
  # register ROM components from './models'
  plugin :rom, {
    default: {
      setup: [:sql, 'sqlite::memory'],
      plugins: [:auto_registration]
    },
    load_path: 'models'
  }
end
```

In situations where your app is loaded from a path that isn’t the `pwd` of the Rack server process, the ROM plugin plays nicely with Roda’s `opts[:root]` setting:

```ruby
class MyApplication < Roda
  # app file is at './app/my_application.rb'
  opts[:root] = 'app'

  # register ROM components from './app/model'
  plugin :rom, {
    default: {
      setup: [:sql, 'sqlite::memory'],
      plugins: [:auto_registration]
    },
    load_path: 'model'
  }
end
```

### Using ROM in Roda routes

With the ROM environment configured, the following instance methods are available in Roda routes:

#### rom

Provides an instance of the ROM environment:

```ruby
route do |r|
  rom          # access :default ROM environment
  rom(:memory) # access :memory ROM environment
end
```

#### relation(name, environment = :default)

Provides an instance of the named relation:

```ruby
route do |r|
  r.on('catalog') do
    # access :products relation from the :default ROM environment
    @products = relation(:products).in_stock

    r.is('category/:category') do |category|
      @products.by_category(category)
    end
  end

  r.on('users') do
    # access :users relation from the :sql ROM environment
    @users = relation(:users, :sql)

    r.is(':user_id') do |user_id|
      @users.by_id(user_id)
    end
  end
end
```

#### command(name, environment = :default)

Provides an instance of the named command:

```ruby
route do |r|
  r.is('products') do
    r.post do
      # access :products commands from :default ROM environment
      command(:products).create.call(r['product'])
    end
  end

  r.is('users') do
    r.post do
      # access :users commands from :sql ROM environment
      command(:users, :sql).create.call(r['user'])
    end
  end
end
```

## Community

* [![Gitter chat](https://badges.gitter.im/rom-rb/chat.png)](https://gitter.im/rom-rb/chat)
* [Ruby Object Mapper](https://groups.google.com/forum/#!forum/rom-rb) mailing list

## License

See `LICENSE` file.
