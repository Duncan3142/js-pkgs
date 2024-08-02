defmodule HermesServerTest do
  use ExUnit.Case
  doctest HermesServer

  test "greets the world" do
    assert HermesServer.hello() == :world
  end
end
