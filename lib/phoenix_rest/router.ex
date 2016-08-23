defmodule PhoenixRest.Router do
  @moduledoc ~S"""
  A DSL to supplement Phoenix Router with a resource-oriented routing algorithm.

  It provides a macro to generate routes that dispatch to specific
  resource handlers.

  Edit `web/web.ex` and add the router:

      def router do
        quote do
          use Phoenix.Router
          use PhoenixRest.Router
        end
      end

  Then use the `resource` macro in your router to match a path with a
  resource handler:

      defmodule MyApp.Router do
        use HelloPhoenix.Web, :router

        resource "/pages/:page", PageResource
      end

  The `resource/2` macro accepts a request of format `"/pages/VALUE"` and
  dispatches it to the `PageResource` module, which must adopt the
  `PlugRest.Resource` behaviour by implementing one or more of the callbacks
  which describe the resource.

  See the `PlugRest` documentation for more details about defining a Resource.

  ## Options

  The macro accepts an optional initial state for the resource. For example:

      resource "/pages/:page", PageResource, state: %{option: true}

  ## Routes

      resource "/hello", HelloResource

  The example above will route any requests for "/hello" to the
  `HelloResource` module.

  A route can also specify parameters which will be available to the
  resource:

      resource "/hello/:name", HelloResource

  The value of the dynamic path segment can be read inside the
  `HelloResource` module:

      def to_html(%{params: params} = conn, state) do
        %{"name" => name} = params
        {"Hello #{name}!", conn, state}
      end

  ## Options

  The router accepts a list of options:

    * `:known_methods` - custom list of HTTP methods known by your
      server, for example: `["GET", "HEAD", "OPTIONS", "TRACE"]`

  If a resource allows any HTTP methods that are not in the default
  set (GET, HEAD, POST, PUT, PATCH, DELETE, and OPTIONS), it must
  implement the `known_methods` callback which returns a list of all
  the HTTP verbs your server should know about.

  Because these known methods can only be returned by your resource at
  runtime, you also need to tell PhoenixRest about them, so that it
  can compile your routes correctly using the Phoenix match macro:

      use PhoenixRest.Router, known_methods: ["GET", "HEAD", "OPTIONS", "TRACE"]

  Nota bene: if a resource is requested using an HTTP verb that is not
  in the list of known methods, Phoenix will raise a `NoRouterError`
  rather than return a `501 Not Implemented` status code.
  """

  @known_methods ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]

  @doc false
  defmacro __using__(options) do
    quote location: :keep do
      use Phoenix.Router
      import PhoenixRest.Router

      unquote(defs(options))
    end
  end

  # Define a function that will be used by the resource macro to
  # generate a match for every resource and known method.
  defp defs(options) do
    known_methods =
      Keyword.get(options, :known_methods, @known_methods)
      |> Enum.map(&String.downcase/1)
      |> Enum.map(&String.to_atom/1)

    quote bind_quoted: [known_methods: known_methods] do
      var!(add_resource, PhoenixRest.Router) = fn (path, handler, options) ->

        for method <- known_methods do
          match method, path, handler, options
        end
      end
    end
  end

  defmacro resource(path, handler, options \\ []) do
    add_resource(path, handler, options)
  end

  defp add_resource(path, handler, options) do
    quote bind_quoted: [path: path, handler: handler, options: options] do
      var!(add_resource, PhoenixRest.Router).(path, handler, options)
    end
  end
end
