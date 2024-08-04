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
    kids = [
      {DynamicSupervisor, name: Hermes.BucketSupervisor, strategy: :one_for_one},
      {Otp.Registry, name: Hermes.BucketRegistry, supervisor: Hermes.BucketSupervisor}
    ]

    Supervisor.start_link(kids, strategy: :one_for_all, name: __MODULE__)
  end
end
