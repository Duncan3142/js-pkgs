defmodule HermesServer do
  @moduledoc """
  Documentation for `HermesServer`.
  """

  require Logger

  @doc """
  Hello world.

  ## Examples

      iex> HermesServer.hello()
      :world

  """
  def hello do
    :world
  end

  def accept(port) do
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
    loop_acceptor(listen_socket)
  end

  defp loop_acceptor(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    {:ok, pid} = Task.Supervisor.start_child(HermesServer.TaskSupervisor, fn -> serve(socket) end)
    :ok = :gen_tcp.controlling_process(socket, pid)
    loop_acceptor(listen_socket)
  end

  defp serve(socket) do
    output =
      with {:ok, line} <- read_line(socket),
           {:ok, command} <- HermesServer.Command.parse(line),
           do: HermesServer.Command.run(command)

    write_line(socket, output)
    serve(socket)
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
    :gen_tcp.send(socket, "ERROR - KEY NOT FOUND\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    exit(:shutdown)
  end

  defp write_line(socket, {:error, err}) do
    :gen_tcp.send(socket, "UNEXPECTED ERROR\n")
    exit(err)
  end
end
