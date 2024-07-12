defmodule Otp.RegistryTest do
  @moduledoc """
  Tests for OTP.Registry.
  """
  use ExUnit.Case, async: true

  setup do
    start_supervised!({DynamicSupervisor, name: AnotherBucketSupervisor, strategy: :one_for_one})
    registry = start_supervised!({Otp.Registry, [supervisor: AnotherBucketSupervisor]})

    Otp.Registry.create(registry, "setup")
    %{registry: registry}
  end

  test "Missing bucket", %{registry: registry} do
    :nothing = Otp.Registry.get(registry, "missing")
  end

  test "Get bucket", %{registry: registry} do
    {:just, bucket} = Otp.Registry.get(registry, "setup")
    assert is_pid(bucket)
  end

  test "removes stopped buckets", %{registry: registry} do
    {:just, bucket} = Otp.Registry.get(registry, "setup")
    Agent.stop(bucket)
    :nothing = Otp.Registry.get(registry, "setup")
  end

  test "removes crashed buckets", %{registry: registry} do
    {:just, bucket} = Otp.Registry.get(registry, "setup")
    Agent.stop(bucket, :kill)
    :nothing = Otp.Registry.get(registry, "setup")
  end
end
