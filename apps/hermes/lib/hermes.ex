defmodule Hermes.Application do
  @moduledoc """
  Documentation for `Hermes`.
  """

  use Application

  @doc """
  start
  """
  @impl true
  def start(_type, _args) do
    Otp.Super.start_link(name: Hermes.Supervisor)
  end
end
