defmodule Otp.Super do
  @moduledoc """
  Registry supervisor
  """

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :meow, opts)
  end

  @impl true
  def init(:meow) do
    kids = [
      {DynamicSupervisor, name: MyBucketSupervisor, strategy: :one_for_one},
      {Otp.Registry, name: MyRegistry}
    ]

    Supervisor.init(kids, strategy: :one_for_all)
  end
end
