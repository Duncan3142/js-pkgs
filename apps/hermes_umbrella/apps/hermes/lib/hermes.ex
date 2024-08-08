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
      {Hermes.Registry, name: Hermes.BucketRegistry, supervisor: Hermes.BucketSupervisor},
      {Task.Supervisor, name: Hermes.RouterTasks, strategy: :one_for_one}
    ]

    Supervisor.start_link(kids, strategy: :one_for_all, name: __MODULE__)
  end
end
