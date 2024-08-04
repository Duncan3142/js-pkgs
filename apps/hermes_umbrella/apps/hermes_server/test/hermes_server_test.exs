defmodule HermesServerTest do
  @moduledoc """
  Integration tests for HermesServer.
  """
  use ExUnit.Case

  setup do
    Application.stop(:hermes)
    :ok = Application.start(:hermes)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect(~c"localhost", 4040, opts)
    %{socket: socket}
  end

  test "server behaviour", %{socket: socket} do
    assert make_request(socket, "UNKNOWN shopping\n") == "ERROR - UNKNOWN_COMMAND\n"
  end

  defp make_request(socket, text) do
    :ok = :gen_tcp.send(socket, text)
    {:ok, response} = :gen_tcp.recv(socket, 0, 5000)
    response
  end
end
