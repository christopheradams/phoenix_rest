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
  """

  @known_methods ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]

  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      use Phoenix.Router
      import PhoenixRest.Router
    end
  end

  defmacro resource(path, handler, options \\ []) do
    add_resource(path, handler, options)
  end

  defp add_resource(path, handler, options) do
    for known_method <- @known_methods do
      method = known_method |> String.downcase |> String.to_atom
      quote bind_quoted: [method: method, path: path, handler: handler,
                          options: options] do
        match method, path, handler, options
      end
    end
  end
end
