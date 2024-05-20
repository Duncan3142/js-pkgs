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

  def new do
    {:ok, pid} = Task.start_link(fn -> loop(%{}) end)
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

pid = KV.new()
KV.set(pid, :hello, "world")
KV.set(pid, :meow, "meow")
KV.set(pid, :one, 1)

IO.puts(KV.get(pid, :hello))
IO.puts(KV.get(pid, :meow))
IO.puts(KV.get(pid, :one))
