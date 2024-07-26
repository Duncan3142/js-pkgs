defmodule Otp.RegistryTest do
  @moduledoc """
  Tests for OTP.Registry.
  """
  use ExUnit.Case, async: true

  setup ctx do
    start_supervised!({DynamicSupervisor, name: :"#{ctx.test}Supervisor", strategy: :one_for_one})

    start_supervised!({Otp.Registry, supervisor: :"#{ctx.test}Supervisor", name: ctx.test})

    %{registry: ctx.test}
  end

  test "Missing bucket", %{registry: registry} do
    :nothing = Otp.Registry.get(registry, "missing")
  end

  test "Get bucket", %{registry: registry} do
    Otp.Registry.create(registry, "get")
    {:just, bucket} = Otp.Registry.get(registry, "get")
    assert is_pid(bucket)
  end

  test "removes stopped buckets", %{registry: registry} do
    Otp.Registry.create(registry, "stopped")
    {:just, bucket} = Otp.Registry.get(registry, "stopped")
    Agent.stop(bucket)
    Otp.Registry.ping(registry)
    :nothing = Otp.Registry.get(registry, "stopped")
  end

  test "removes crashed buckets", %{registry: registry} do
    Otp.Registry.create(registry, "crashed")
    {:just, bucket} = Otp.Registry.get(registry, "crashed")
    Agent.stop(bucket, :kill)
    Otp.Registry.ping(registry)
    :nothing = Otp.Registry.get(registry, "crashed")
  end
end
