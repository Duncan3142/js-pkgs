defmodule Otp.Registry do
  @moduledoc """
  GenSerer based bucket registry.
  """
  use GenServer

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ []) do
    super = opts[:supervisor] || MyBucketSupervisor
    GenServer.start_link(__MODULE__, super, Keyword.delete(opts, :supervisor))
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
  def init(super) do
    {:ok, {%{}, %{}, super}}
  end

  @impl true
  def handle_call({:get, name}, _from, {names, refs, super}) do
    {:reply, Map.get(names, name, :nothing), {names, refs, super}}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs, super}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = DynamicSupervisor.start_child(super, OTP.Bucket)
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, {:just, bucket})

      {:noreply, {names, refs, super}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, _}, {names, refs, super}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs, super}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
