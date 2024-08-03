defmodule HermesServer.Command do
  @doc """
  Pares a command string

  ## Examples

    iex> HermesServer.Command.parse("CREATE foo")
    {:ok, {:create, "foo"}}
  """

  def parse(_cmd) do
    :todo
  end
end
