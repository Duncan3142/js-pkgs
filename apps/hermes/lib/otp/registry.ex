defmodule Otp.Registry do
  @moduledoc """
  GenSerer based bucket registry.
  """
  use GenServer

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:get, name}, _from, registry) do
    {:reply, Map.get(registry, name, :nothing), registry}
  end

  @impl true
  def handle_cast({:create, name}, registry) do
    if Map.has_key?(registry, name) do
      {:noreply, registry}
    else
      {:ok, bucket} = OTP.Bucket.start_link()
      {:noreply, Map.put(registry, name, bucket)}
    end
  end
end
