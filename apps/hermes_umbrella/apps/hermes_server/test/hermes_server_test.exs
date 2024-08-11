defmodule HermesServerTest do
  @moduledoc """
  Integration tests for HermesServer.
  """
  use ExUnit.Case

  @moduletag :capture_log

  setup do
    Application.stop(:hermes)
    :ok = Application.start(:hermes)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    port = String.to_integer(System.get_env("PORT") || "4040")
    {:ok, socket} = :gen_tcp.connect(~c"localhost", port, opts)
    %{socket: socket}
  end

  test "server behaviour", %{socket: socket} do
    assert make_request(socket, "UNKNOWN shopping\n") == "ERROR - UNKNOWN_COMMAND\n"
    assert make_request(socket, "GET shopping meow\n") == "ERROR - BUCKET_NOT_FOUND\n"
    assert make_request(socket, "CREATE shopping\n") == "OK\n"
    assert make_request(socket, "GET shopping meow\n") == "ERROR - KEY_NOT_FOUND\n"
    assert make_request(socket, "PUT shopping foo bar\n") == "OK\n"
    assert make_request(socket, "GET shopping foo\n") == "bar\nOK\n"
    assert make_request(socket, "DELETE shopping foo\n") == "OK\n"
    assert make_request(socket, "GET shopping foo\n") == "ERROR - KEY_NOT_FOUND\n"
  end

  defp receive_response(socket, acc \\ "", wait \\ 1000) do
    case :gen_tcp.recv(socket, 0, wait) do
      {:ok, response} -> receive_response(socket, "#{acc}#{response}", 0)
      {:error, :timeout} -> acc
    end
  end

  defp make_request(socket, text) do
    :ok = :gen_tcp.send(socket, text)
    receive_response(socket)
  end
end
