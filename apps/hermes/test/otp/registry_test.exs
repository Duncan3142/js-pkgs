defmodule Otp.RegistryTest do
  @moduledoc """
  Tests for OTP.Registry.
  """
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(Otp.Registry)
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
end
