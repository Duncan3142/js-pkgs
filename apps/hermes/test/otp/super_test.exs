defmodule Otp.SuperTest do
  @moduledoc """
  Tests for OTP.Super.

  """
  require Logger

  use ExUnit.Case, async: true

  setup do
    sup = start_supervised!(Otp.Super)
    %{sup: sup}
  end

  test "starts the registry", %{sup: sup} do
    [{_, pid, _, _}] = Supervisor.which_children(sup)
    reg = Process.whereis(MyRegistry)

    assert pid == reg
  end

  test "restarts the registry", %{sup: sup} do
    reg = Process.whereis(MyRegistry)

    mon = Process.monitor(reg)

    Process.exit(reg, :kill)

    receive do
      {:DOWN, ^mon, :process, ^reg, _} -> :ok
    after
      500 -> flunk("Registry did not die")
    end

    [{_, pid, _, _}] = Supervisor.which_children(sup)

    assert is_pid(pid)
    assert pid != reg
  end

  test "names the registry" do
    reg = Process.whereis(MyRegistry)
    res = Otp.Registry.get(reg, "void")
    assert res == :nothing
  end
end
