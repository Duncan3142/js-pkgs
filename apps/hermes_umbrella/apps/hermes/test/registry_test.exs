defmodule Hermes.RegistryTest do
  @moduledoc """
  Tests for Hermes.Registry.
  """
  use ExUnit.Case, async: true

  setup ctx do
    start_supervised!({DynamicSupervisor, name: :"#{ctx.test}Supervisor", strategy: :one_for_one})

    start_supervised!({Hermes.Registry, supervisor: :"#{ctx.test}Supervisor", name: ctx.test})

    %{registry: ctx.test}
  end

  test "Missing bucket", %{registry: registry} do
    :nothing = Hermes.Registry.get(registry, "missing")
  end

  test "Get bucket", %{registry: registry} do
    Hermes.Registry.create(registry, "get")
    {:just, bucket} = Hermes.Registry.get(registry, "get")
    assert is_pid(bucket)
  end

  test "removes stopped buckets", %{registry: registry} do
    Hermes.Registry.create(registry, "stopped")
    {:just, bucket} = Hermes.Registry.get(registry, "stopped")
    Agent.stop(bucket)
    Hermes.Registry.ping(registry)
    :nothing = Hermes.Registry.get(registry, "stopped")
  end

  test "removes crashed buckets", %{registry: registry} do
    Hermes.Registry.create(registry, "crashed")
    {:just, bucket} = Hermes.Registry.get(registry, "crashed")
    Agent.stop(bucket, :kill)
    Hermes.Registry.ping(registry)
    :nothing = Hermes.Registry.get(registry, "crashed")
  end
end
