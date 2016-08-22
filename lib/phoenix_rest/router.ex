defmodule PhoenixRest.Router do

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
