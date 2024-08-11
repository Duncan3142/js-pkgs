defmodule Hermes.Router.Core do
  @moduledoc """
  Bucket router core logic
  """
  def call(entries, bucket, mod, fun, args) do
    first_byte = :binary.first(bucket)

    {_, node_atom} =
      Enum.find(entries, fn {byte_range, _} -> first_byte in byte_range end) ||
        raise %Hermes.Router.Error{bucket: bucket, entries: entries}

    if node_atom == node() do
      apply(mod, fun, args)
    else
      {Hermes.RouterTasks, node_atom}
      |> Task.Supervisor.async(Hermes.Router.Core, :call, [entries, bucket, mod, fun, args])
      |> Task.await()
    end
  end
end
