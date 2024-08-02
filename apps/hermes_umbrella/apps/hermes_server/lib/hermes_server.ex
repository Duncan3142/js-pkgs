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
    socket |> read_line() |> write_line(socket)
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, line} = :gen_tcp.recv(socket, 0)
    line
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
