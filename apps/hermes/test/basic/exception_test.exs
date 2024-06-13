defmodule Basic.ExceptionTest do
  use ExUnit.Case, async: true

  test "exception" do
    assert_raise Basic.Exception, fn ->
      raise Basic.Exception, message: "Something went wrong", code: 500
    end
  end
end
