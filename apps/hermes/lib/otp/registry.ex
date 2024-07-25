defmodule Otp.Registry do
  @moduledoc """
  GenSerer based bucket registry.
  """
  use GenServer

  # Client API

  @doc """
  Starts the registry.
  # Options
  * `:supervisor` - The supervisor to start the buckets under.
  * `:name` - The name of the registry.
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
    case :ets.lookup(server, name) do
      [{^name, res}] -> res
      [] -> :nothing
    end
  end

  @doc """
  Create a new bucket by name.
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end

  # Server API

  @impl true
  def init({supervisor, reg_name}) do
    names = :ets.new(reg_name, [:named_table, read_concurrency: true])
    refs = %{}
    {:ok, {names, refs, {supervisor}}}
  end

  @impl true
  def handle_call({:create, name}, _, {names, refs, {supervisor}}) do
    case get(names, name) do
      {:just, _} ->
        {:reply, false, {names, refs, {supervisor}}}

      :nothing ->
        {:ok, bucket} = DynamicSupervisor.start_child(supervisor, OTP.Bucket)
        ref = Process.monitor(bucket)
        refs = Map.put(refs, ref, name)
        :ets.insert(names, {name, {:just, bucket}})

        {:reply, true, {names, refs, {supervisor}}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _, _}, {names, refs, props}) do
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs, props}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end
end
