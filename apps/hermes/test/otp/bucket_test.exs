defmodule OTP.BucketTest do
  use ExUnit.Case, async: true

  test "set bucket by key" do
    {:ok, bucket} = OTP.Bucket.start_link()
    r = OTP.Bucket.get(bucket, "key")
    assert r == :nothing
    OTP.Bucket.set(bucket, "key", "value")
    {:just, value} = OTP.Bucket.get(bucket, "key")
    assert value == "value"
  end
end
