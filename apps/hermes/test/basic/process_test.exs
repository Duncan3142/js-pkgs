defmodule Basic.ProcessTest do
  use ExUnit.Case, async: true

  defp do_receive do
    receive do
      {:hello, msg} -> msg
      {:meow, msg} -> String.upcase(msg)
      _ -> :no_match
    end
  end

  test "process" do
    send(self(), {:hello, "world"})
    send(self(), {:meow, "meow"})
    send(self(), 0)

    r = do_receive()

    assert r == "world"

    r = do_receive()

    assert r == "MEOW"

    r = do_receive()

    assert r == :no_match

    parent = self()
    sid = spawn(fn -> send(parent, {:hello, self()}) end)

    r =
      receive do
        {:hello, pid} -> "Got hello from #{inspect(pid)}"
      end

    assert r == "Got hello from #{inspect(sid)}"
  end
end
