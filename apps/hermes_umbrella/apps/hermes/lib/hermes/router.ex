defmodule Hermes.Router do
  @doc """
  Bucket router
  """
  def route(bucket, mod, fun, args)
  do
    first_byte = :binary.first(bucket)
    # first_grapheme = String.at(bucket, 0)

    {_, node_atom} =  Enum.find(routing_table(), fn {byte_range, _} -> first_byte in byte_range end) || no_route_error(bucket)

    if node_atom == node() do
      apply(mod, fun, args)
    else
      {Hermes.RouterTasks, node_atom} |> Task.Supervisor.async(Hermes.Router, :route, [bucket, mod, fun, args]) |> Task.await()
    end
  end

  defp routing_table do
    [
      {?a..?m, :"foo@l14"},
      {?n..?z, :"bar@l14"}
    ]
  end

  defp no_route_error(bucket) do
    raise ArgumentError, "No route found for #{inspect bucket} in table #{inspect routing_table()}"
  end

end
