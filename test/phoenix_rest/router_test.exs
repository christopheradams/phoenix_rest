defmodule PhoenixRest.RouterTest do
  use ExUnit.Case
  use Plug.Test

  defmodule HelloResource do
    use PhoenixRest.Resource

    def to_html(conn, state) do
      {"Hello world!", conn, state}
    end
  end

  defmodule MessageResource do
    use PhoenixRest.Resource

    def to_html(%{params: params} = conn, state) do
      %{"message" => message} = params
      {"Hello #{message}!", conn, state}
    end
  end

  defmodule RestRouter do
    use PhoenixRest.Router, known_methods: ["GET", "HEAD", "OPTIONS", "POST", "MOVE"]

    resource "/hello", HelloResource
    resource "/hello/:message", MessageResource
  end

  test "GET /hello" do
    conn = conn(:get, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 200
    assert conn.resp_body == "Hello world!"
  end

  test "OPTIONS /hello" do
    conn = conn(:options, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 200
    assert (Plug.Conn.get_resp_header(conn, "allow")) == ["HEAD, GET, OPTIONS"]
  end

  test "POST /hello" do
    conn = conn(:post, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 405
    assert (Plug.Conn.get_resp_header(conn, "allow")) == ["HEAD, GET, OPTIONS"]
  end

  test "MOVE /hello" do
    conn = conn(:move, "/hello")

    conn = RestRouter.call(conn, [])

    assert conn.status == 405
  end

  test "PATCH /hello" do
    conn = conn(:patch, "/hello")

    assert_raise Phoenix.Router.NoRouteError, fn ->
      RestRouter.call(conn, [])
    end
  end

  test "GET /hello/:message" do
    conn = conn(:get, "/hello/world")
    conn = RestRouter.call(conn, [])
    assert conn.resp_body == "Hello world!"

    conn = conn(:get, "/hello/everyone")
    conn = RestRouter.call(conn, [])
    assert conn.resp_body == "Hello everyone!"
  end
end
