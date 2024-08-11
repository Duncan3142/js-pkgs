defmodule Hermes.Router.Env do
  @moduledoc """
  Application environment key.
  """
  @enforce_keys [:app, :key]
  defstruct [:app, :key]
end

defimpl Hermes.Router, for: Hermes.Router.Env do
  def route(self, bucket, mod, fun, args) do
    entries = Application.fetch_env!(self.app, self.key)
    Hermes.Router.Core.call(entries, bucket, mod, fun, args)
  end
end
