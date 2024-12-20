defmodule Sophrosyne.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Sophrosyne.Repo,
      {DNSCluster, query: Application.get_env(:sophrosyne, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sophrosyne.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sophrosyne.Finch}
      # Start a worker by calling: Sophrosyne.Worker.start_link(arg)
      # {Sophrosyne.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Sophrosyne.Supervisor)
  end
end
