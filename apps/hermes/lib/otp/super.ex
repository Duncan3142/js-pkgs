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
      {Otp.Registry, name: MyRegistry}
    ]

    Supervisor.init(kids, strategy: :one_for_one)
  end
end
