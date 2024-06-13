defmodule OTP.Bucket do
  def start_link(opts \\ []) do
    Agent.start_link(fn -> %{} end, opts)
  end

  def set(bucket, key, value) do
    Agent.update(bucket, fn map -> Map.put(map, key, {:just, value}) end)
  end

  def get(bucket, key) do
    Agent.get(bucket, fn map ->
      case Map.get(map, key, :nothing) do
        :nothing -> :nothing
        {:just, value} -> {:just, value}
      end
    end)
  end
end
