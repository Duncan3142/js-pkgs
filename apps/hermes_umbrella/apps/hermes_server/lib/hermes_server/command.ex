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

  def run(bucket_registry_pid, command)

  def run(pid, {:create, bucket}) do
    Hermes.Registry.create(pid, bucket)

    {:ok, "OK\n"}
  end

  def run(pid, {:get, bucket, key}) do
    lookup(pid, bucket, fn bucket_pid ->
      case Hermes.Bucket.get(bucket_pid, key) do
        :nothing -> {:error, :key_not_found}
        {:just, value} -> {:ok, "#{value}\nOK\n"}
      end
    end)
  end

  def run(pid, {:put, bucket, key, value}) do
    lookup(pid, bucket, fn bucket_pid ->
      Hermes.Bucket.set(bucket_pid, key, value)
      {:ok, "OK\n"}
    end)
  end

  def run(pid, {:delete, bucket, key}) do
    lookup(pid, bucket, fn bucket_pid ->
      Hermes.Bucket.delete(bucket_pid, key)
      {:ok, "OK\n"}
    end)
  end

  defp lookup(bucket_registry_pid, bucket_name, action) do
    case Hermes.Router.route(bucket_name, Hermes.Registry, :get, [
           bucket_registry_pid,
           bucket_name
         ]) do
      {:just, bucket_pid} -> action.(bucket_pid)
      :nothing -> {:error, :bucket_not_found}
    end
  end
end
