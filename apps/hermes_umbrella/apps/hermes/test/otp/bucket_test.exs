defmodule OTP.BucketTest do
  @moduledoc """
  Tests for OTP.Bucket.
  """
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(OTP.Bucket)
    OTP.Bucket.set(bucket, "setup", "init")
    %{bucket: bucket}
  end

  test "read empty key", %{bucket: bucket} do
    r = OTP.Bucket.get(bucket, "key")
    assert r == :nothing
  end

  test "set value by key", %{bucket: bucket} do
    OTP.Bucket.set(bucket, "key", "value")
    {:just, value} = OTP.Bucket.get(bucket, "key")
    assert value == "value"
  end

  test "delete value by key", %{bucket: bucket} do
    {:just, value} = OTP.Bucket.delete(bucket, "setup")
    assert value == "init"
    r = OTP.Bucket.get(bucket, "setup")
    assert r == :nothing
  end
end
