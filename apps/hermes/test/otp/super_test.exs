defmodule Otp.SuperTest do
  @moduledoc """
  Tests for OTP.Super.

  """

  use ExUnit.Case, async: false

  setup do
    {:ok, sup} = Otp.Super.start_link()

    %{sup: sup}
  end

  test "starts the registry", %{sup: sup} do
    [{_, pid, _, _}] = Supervisor.which_children(sup)

    assert is_pid(pid)
  end

  # test "restarts the registry", %{sup: sup} do
  #   [{_, pid, _, _}] = Supervisor.which_children(sup)

  #   Process.exit(pid, :kill)

  #   [{_, pid, _, _}] = Supervisor.which_children(sup)

  #   assert is_pid(pid)
  # end

  # test "names the registry", %{sup: sup} do
  #   [{_, pid, _, _}] = Supervisor.which_children(sup)
  #   res = Otp.Registry.get(pid, "void")
  #   assert res == :nothing
  # end
end
