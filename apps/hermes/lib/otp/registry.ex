defmodule Otp.Registry do
  @moduledoc """
  GenSerer based bucket registry.
  """
  use GenServer

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ []) do
    supervisor = Keyword.get(opts, :supervisor, MyBucketSupervisor)
    reg_name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, {supervisor, reg_name}, opts)
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
  def init(props) do
    {:ok, {%{}, %{}, props}}
  end

  @impl true
  def handle_call({:get, name}, _from, {names, refs, props}) do
    {:reply, Map.get(names, name, :nothing), {names, refs, props}}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs, {supervisor, reg_name}}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, bucket} = DynamicSupervisor.start_child(supervisor, OTP.Bucket)
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, {:just, bucket})

      {:noreply, {names, refs, {supervisor, reg_name}}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, _}, {names, refs, props}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs, props}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
