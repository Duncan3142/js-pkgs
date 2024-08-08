defmodule Hermes.Bucket do
  @moduledoc """
  Agent based key-value store.
  """
  use Agent, restart: :temporary

  @doc """
  Starts a new bucket linked to the current process.
  """
  def start_link(opts \\ []) do
    Agent.start_link(fn -> %{} end, opts)
  end

  @doc """
  Starts a new bucket.
  """
  def start(opts \\ []) do
    Agent.start(fn -> %{} end, opts)
  end

  @doc """
  Stops a bucket.
  """
  def stop(bucket) do
    Agent.stop(bucket)
  end

  @doc """
  Sets a value in a bucket by key.
  """
  def set(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, {:just, value}))
  end

  @doc """
  Gets a value from a bucket by key.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key, :nothing))
  end

  @doc """
  Deletes a value from a bucket by key.
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
