defmodule OTP.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = OTP.Bucket.start_link([])
    OTP.Bucket.set(bucket, "setup", "init")
    %{bucket: bucket}
  end

  test "read empty key", %{bucket: bucket} do
    r = OTP.Bucket.get(bucket, "key")
    assert r == :nothing
  end

  test "set bucket by key", %{bucket: bucket} do
    OTP.Bucket.set(bucket, "key", "value")
    {:just, value} = OTP.Bucket.get(bucket, "key")
    assert value == "value"
  end

  test "delete bucket by key", %{bucket: bucket} do
    {:just, value} = OTP.Bucket.delete(bucket, "setup")
    assert value == "init"
    r = OTP.Bucket.get(bucket, "setup")
    assert r == :nothing
  end
end
