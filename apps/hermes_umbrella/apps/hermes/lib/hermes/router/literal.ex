defmodule Hermes.Router.Literal do
  @moduledoc """
  Application environment key.
  """
  @enforce_keys [:entries]
  defstruct [:entries]
end

defimpl Hermes.Router, for: Hermes.Router.Literal do
  def route(self, bucket, mod, fun, args) do
    Hermes.Router.Core.call(self.entries, bucket, mod, fun, args)
  end
end
