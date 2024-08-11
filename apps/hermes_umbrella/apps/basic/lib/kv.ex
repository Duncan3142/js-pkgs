defmodule Basic.KV do
  @moduledoc """
  Key-value store.
  """
  def get(pid, key) do
    send(pid, {:get, key, self()})

    receive do
      value -> value
    end
  end

  def set(pid, key, value) do
    send(pid, {:put, key, value})
  end

  def start_link(pname) do
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
