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

  The `resource/4` macro accepts a request of format `"/pages/VALUE"` and
  and dispatches it to `PageResource`, which must be a Plug module.

  See `PhoenixRest.Resource` for information on how to write a Plug
  module that implements REST semantics.

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

  @doc false
  defmacro __using__(_options) do
    quote location: :keep do
      require Phoenix.Router

      import Phoenix.Router
      import PhoenixRest.Router

      unquote(defs())
    end
  end

  # Define a function that will be used by the resource macro to
  # generate a router matches for each resource.
  @spec defs() :: Macro.t()
  defp defs() do
    quote do
      var!(add_resource, PhoenixRest.Router) = fn path, plug, plug_opts, options ->
        match(:*, path, plug, plug_opts, options)
      end
    end
  end

  ## Resource

  @doc """
  Main API to define resource routes.

  It accepts an expression representing the path, a Plug module, the
  options for the plug, and options for the macro.

  ## Examples

      resource "/path", PlugModule, plug_opts, options

  ## Options

  `resource/4` accepts the same options as `PhoenixRouter.match/5`

  """
  @spec resource(String.t(), atom(), any(), list()) :: Macro.t()
  defmacro resource(path, plug, plug_opts \\ [], options \\ []) do
    add_resource(path, plug, plug_opts, options)
  end

  @spec add_resource(String.t(), atom(), any(), list()) :: Macro.t()
  defp add_resource(path, plug, plug_opts, options) do
    quote bind_quoted: [path: path, plug: plug, plug_opts: plug_opts, options: options] do
      var!(add_resource, PhoenixRest.Router).(path, plug, plug_opts, options)
    end
  end
end
