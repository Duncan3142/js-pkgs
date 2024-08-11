defmodule Hermes.Router.Error do
  @enforce_keys [:bucket, :entries]
  defexception [:bucket, :entries]

  def message(e) do
    "No route found for #{inspect(e.bucket)} in table #{inspect(e.entries)}"
  end
end
