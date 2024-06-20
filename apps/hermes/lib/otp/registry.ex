defmodule Otp.Registry do
  @moduledoc """
  GenSerer based bucket registry.
  """
  use GenServer

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :empty, opts)
  end

  @doc """
  Get the bucket by name.
  """
  def get(server, name) do
    GenServer.call(server, {:get, name})
  end

  @doc """
  Create a new bucket by name.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @impl true
  def init(:empty) do
    {:ok, {%{}, %{}}}
  end

  @impl true
  def handle_call({:get, name}, _from, {names, refs}) do
    {:reply, Map.get(names, name, :nothing), {names, refs}}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = OTP.Bucket.start_link()
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, {:just, bucket})

      {:noreply, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, _}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end
end
