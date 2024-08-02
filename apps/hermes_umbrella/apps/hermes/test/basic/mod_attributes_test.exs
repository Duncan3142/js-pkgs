defmodule Basic.ModAttributesTest do
  use ExUnit.Case, async: true

  test "sha" do
    assert Basic.ModAttr.sha() |> String.match?(~r"^[0-9a-f]{40}$")
  end

  test "path" do
    assert Basic.ModAttr.path() |> String.match?(~r":/usr/bin:")
  end
end
