defmodule HermesServer.CommandTest do
  @moduledoc """
  HermesServer.Command tests
  """
  use ExUnit.Case, async: true

  @moduletag :distributed

  doctest HermesServer.Command

  setup ctx do
    sup_name = :"#{ctx.test}super"
    reg_name = :"#{ctx.test}reg"
    start_supervised!({DynamicSupervisor, [name: sup_name, strategy: :one_for_one]})
    start_supervised!({Hermes.Registry, [supervisor: sup_name, name: reg_name]})
    HermesServer.Command.run(reg_name, {:create, "setup_bucket"})
    HermesServer.Command.run(reg_name, {:put, "setup_bucket", "setup_key", "setup_value"})

    %{reg_name: reg_name}
  end

  test "run get", %{reg_name: reg_name} do
    assert HermesServer.Command.run(reg_name, {:get, "setup_bucket", "setup_key"}) ==
             {:ok, "setup_value\nOK\n"}
  end

  test "run put", %{reg_name: reg_name} do
    assert HermesServer.Command.run(reg_name, {:put, "setup_bucket", "setup_key", "new"}) ==
             {:ok, "OK\n"}

    assert HermesServer.Command.run(reg_name, {:get, "setup_bucket", "setup_key"}) ==
             {:ok, "new\nOK\n"}
  end

  test "run delete", %{reg_name: reg_name} do
    assert HermesServer.Command.run(reg_name, {:delete, "setup_bucket", "setup_key"}) ==
             {:ok, "OK\n"}

    assert HermesServer.Command.run(reg_name, {:get, "setup_bucket", "setup_key"}) ==
             {:error, :key_not_found}
  end

  test "run get - missing bucket", %{reg_name: reg_name} do
    assert HermesServer.Command.run(reg_name, {:get, "unknown", "unknown"}) ==
             {:error, :bucket_not_found}
  end

  test "run get - missing key", %{reg_name: reg_name} do
    assert HermesServer.Command.run(reg_name, {:get, "setup_bucket", "unknown"}) ==
             {:error, :key_not_found}
  end
end
