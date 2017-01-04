defmodule PhoenixRest.Resource do
  @moduledoc ~S"""
  Define callbacks and REST semantics for a Resource behaviour

  Based on Cowboy's cowboy_rest module. It operates on a Plug connection and a
  handler module which implements one or more of the optional callbacks.

  For example, the route:

      resource "/users/:username", MyApp.UserResource

  will invoke the `init/2` function of `MyApp.UserResource` if it exists
  and then continue executing to determine the state of the resource. By
  default the resource must implement a `to_html` content handler which
  returns a "text/html" representation of the resource.

      defmodule MyApp.UserResource do
        use PhoenixRest.Resource

        def init(conn, state) do
          {:ok, conn, state}
        end

        def allowed_methods(conn, state) do
          {["GET"], conn, state}
        end

        def resource_exists(%{params: params} = conn, _state)
          username = params["username"]
          # Look up user
          state = %{name: "John Doe", username: username}
          {true, conn, state}
        end

        def content_types_provided(conn, state) do
          {[{"text/html", :to_html}], conn, state}
        end

        def to_html(conn, %{name: name} = state) do
          {"<p>Hello, #{name}</p>", conn, state}
        end
      end

  Each callback accepts a `%Plug.Conn{}` struct and the current state
  of the resource, and returns a three-element tuple of the form `{value,
  conn, state}`.

  The resource callbacks are named below, along with their default
  values. Some functions are skipped if they are undefined. Others have
  no default value.

      allowed_methods        : ["GET", "HEAD", "OPTIONS"]
      allow_missing_post     : true
      charsets_provided      : skip
      content_types_accepted : none
      content_types_provided : [{{"text", "html", %{}}, :to_html}]
      delete_completed       : true
      delete_resource        : false
      expires                : nil
      forbidden              : false
      generate_etag          : nil
      is_authorized          : true
      is_conflict            : false
      known_methods          : ["GET", "HEAD", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"]
      languages_provided     : skip
      last_modified          : nil
      malformed_request      : false
      moved_permanently      : false
      moved_temporarily      : false
      multiple_choices       : false
      options                : :ok
      previously_existed     : false
      resource_exists        : true
      service_available      : true
      uri_too_long           : false
      valid_content_headers  : true
      valid_entity_length    : true
      variances              : []

  You must also define the content handler callbacks that are specified
  through `content_types_accepted/2` and `content_types_provided/2`. It is
  conventional to name the functions after the content types that they
  handle, such as `from_html` and `to_html`.

  The handler function which provides a representation of the resource
  must return a three element tuple of the form `{body, conn, state}`,
  where `body` is one of:

  * `binary()`, which will be sent with `send_resp/3`
  * `{:chunked, Enum.t}`, which will use `send_chunked/2`
  * `{:file, binary()}`, which will use `send_file/3`

  You can halt the resource handling from any callback and return a manual
  response like so:

      response = send_resp(conn, status_code, resp_body)
      {:stop, response, state}

  The content accepted handlers defined in `content_types_accepted` will be
  called for POST, PUT, and PATCH requests. By default, the response body will
  be empty. If desired, you can set the response body like so:

      conn2 = put_rest_body(conn, "#{conn.method} was successful")
      {true, conn2, state}

  ## More Information

  The [documentation for
  PlugRest.Resource](https://hexdocs.pm/plug_rest/PlugRest.Resource.html)
  has more details.

  """
  @doc false
  defmacro __using__(_) do
    quote do
      use PlugRest.Resource
    end
  end
end
