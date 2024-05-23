defmodule KV do
  def get(pid, key) do
    send(pid, {:get, key, self()})

    receive do
      value -> value
    end
  end

  def set(pid, key, value) do
    send(pid, {:put, key, value})
  end

  def new(pname) do
    {:ok, pid} = Task.start_link(fn -> loop(%{}) end)
    Process.register(pid, pname)
    pid
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))
        loop(map)

      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end

KV.new(:kv)
:kv |> KV.set(:hello, "world")
:kv |> KV.set(:meow, "meow")
:kv |> KV.set(:one, 1)

:kv |> KV.get(:hello) |> IO.puts()
:kv |> KV.get(:meow) |> IO.puts()
:kv |> KV.get(:one) |> IO.puts()

pid =
  spawn(fn ->
    receive do
      {type, from, reply_as, req} ->
        IO.inspect({type, from, reply_as, req})
        send(from, {:io_reply, reply_as, :ok})
    end
  end)

IO.write(pid, "hello")
