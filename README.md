# PhoenixRest

Resource routing and REST behaviour for Phoenix web applications.

PhoenixRest integrates the
[PlugRest](https://github.com/christopheradams/plug_rest) library into
your Phoenix application by making a new `resource` macro available in
the existing router.

## Hello World

Add a new route to your router to match a path with a resource
handler:

```elixir
defmodule HelloPhoenix.Router do
  use HelloPhoenix.Web, :router

  resource "/hello", HelloPhoenix.HelloResource
end
```

Create a resource at `web/resources/hello_resource.ex` defining the
resource handler, and implement the optional callbacks:

```elixir
defmodule HelloPhoenix.HelloResource do
  use PlugRest.Resource

  def to_html(conn, state) do
    {"Hello world", conn, state}
  end
end
```


## Installation

Add PhoenixRest to your Phoenix project in three steps:

  1. Add `:phoenix_rest` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:phoenix_rest, "~> 0.1.0"}]
    end
    ```

  2. Ensure `phoenix_rest` is started before your application:

    ```elixir
    def application do
      [applications: [:phoenix_rest]]
    end
    ```

  3. Edit `web/web.ex` and add the router:

    ```elixir
    def router do
      quote do
        use Phoenix.Router
        use PhoenixRest.Router
      end
    end
    ```
