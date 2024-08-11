defmodule Hermes.AppEnvKey do
  @moduledoc """
  Application environment key.
  """
  @enforce_keys [:app, :key]
  defstruct [:app, :key]
end
