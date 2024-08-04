defmodule HermesServer do
  @moduledoc """
  Documentation for `HermesServer`.
  """

  require Logger

  def accept(opts) do
    port = Keyword.fetch!(opts, :port)
    task_supervisor = Keyword.fetch!(opts, :task_supervisor)
    bucket_registry = Keyword.fetch!(opts, :bucket_registry)
    # The options below mean:
    #
    # 1. `:binary` - receives data as binaries (instead of lists)
    # 2. `packet: :line` - receives data line by line
    # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
    # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
    #
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Listening on port #{port}")
    loop_acceptor(listen_socket, task_supervisor, bucket_registry)
  end

  defp loop_acceptor(listen_socket, task_supervisor, bucket_registry) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)

    {:ok, pid} =
      Task.Supervisor.start_child(task_supervisor, fn -> serve(socket, bucket_registry) end)

    :ok = :gen_tcp.controlling_process(socket, pid)
    loop_acceptor(listen_socket, task_supervisor, bucket_registry)
  end

  defp serve(socket, bucket_registry) do
    output =
      with {:ok, line} <- read_line(socket),
           {:ok, command} <- HermesServer.Command.parse(line),
           do: HermesServer.Command.run(bucket_registry, command)

    write_line(socket, output)
    serve(socket, bucket_registry)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :unknown_command}) do
    :gen_tcp.send(socket, "ERROR - UNKNOWN_COMMAND\n")
  end

  defp write_line(socket, {:error, :bucket_not_found}) do
    :gen_tcp.send(socket, "ERROR - BUCKET_NOT_FOUND\n")
  end

  defp write_line(socket, {:error, :key_not_found}) do
    :gen_tcp.send(socket, "ERROR - KEY_NOT_FOUND\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  defp write_line(socket, {:error, err}) do
    :gen_tcp.send(socket, "UNEXPECTED ERROR\n")
    exit(err)
  end
end
