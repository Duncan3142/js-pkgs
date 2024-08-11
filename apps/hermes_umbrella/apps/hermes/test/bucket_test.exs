defmodule Hermes.BucketTest do
  @moduledoc """
  Tests for Hermes.Bucket.
  """
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(Hermes.Bucket)
    Hermes.Bucket.set(bucket, "setup", "init")
    %{bucket: bucket}
  end

  test "read empty key", %{bucket: bucket} do
    r = Hermes.Bucket.get(bucket, "key")
    assert r == :nothing
  end

  test "set value by key", %{bucket: bucket} do
    Hermes.Bucket.set(bucket, "key", "value")
    {:just, value} = Hermes.Bucket.get(bucket, "key")
    assert value == "value"
  end

  test "delete value by key", %{bucket: bucket} do
    {:just, value} = Hermes.Bucket.delete(bucket, "setup")
    assert value == "init"
    r = Hermes.Bucket.get(bucket, "setup")
    assert r == :nothing
  end
end
