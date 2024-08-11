defmodule HermesServer.Command do
  @moduledoc """
  Parses and executes commands
  """

  @doc """
  Pares a command string

  ## Examples


    Valid commands:

      iex> HermesServer.Command.parse("CREATE foo")
      {:ok, {:create, "foo"}}

      iex> HermesServer.Command.parse("CREATE   foo   ")
      {:ok, {:create, "foo"}}

      iex> HermesServer.Command.parse("PUT foo bar true")
      {:ok, {:put, "foo", "bar", "true"}}

      iex> HermesServer.Command.parse("GET foo bar")
      {:ok, {:get, "foo", "bar"}}

      iex> HermesServer.Command.parse("DELETE foo bar")
      {:ok, {:delete, "foo", "bar"}}

    Invalid commands:

      iex> HermesServer.Command.parse("NULL foo")
      {:error, :unknown_command}

      iex> HermesServer.Command.parse("CREATE")
      {:error, :unknown_command}

  """

  def parse(cmd) do
    case String.split(cmd) do
      ["CREATE", bucket] -> {:ok, {:create, bucket}}
      ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
      ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
      ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(router, bucket_registry_pid, command)

  def run(router, pid, {:create, bucket}) do
    Hermes.Router.route(router, bucket, Hermes.Registry, :create, [pid, bucket])
    {:ok, "OK\n"}
  end

  def run(router, pid, {:get, bucket, key}) do
    lookup(router, pid, bucket, fn bucket_pid ->
      case Hermes.Bucket.get(bucket_pid, key) do
        :nothing -> {:error, :key_not_found}
        {:just, value} -> {:ok, "#{value}\nOK\n"}
      end
    end)
  end

  def run(router, pid, {:put, bucket, key, value}) do
    lookup(router, pid, bucket, fn bucket_pid ->
      Hermes.Bucket.set(bucket_pid, key, value)
      {:ok, "OK\n"}
    end)
  end

  def run(router, pid, {:delete, bucket, key}) do
    lookup(router, pid, bucket, fn bucket_pid ->
      Hermes.Bucket.delete(bucket_pid, key)
      {:ok, "OK\n"}
    end)
  end

  defp lookup(router, bucket_registry_pid, bucket_name, action) do
    case Hermes.Router.route(router, bucket_name, Hermes.Registry, :get, [
           bucket_registry_pid,
           bucket_name
         ]) do
      {:just, bucket_pid} -> action.(bucket_pid)
      :nothing -> {:error, :bucket_not_found}
    end
  end
end
