defmodule Basic.ModAttributes.Test do
  use ExUnit.Case, async: true

  test "sha" do
    assert Basic.MyModAttr.sha() |> String.match?(~r"^[0-9a-f]{40}$")
  end

  test "path" do
    assert Basic.MyModAttr.path() |> String.match?(~r":/usr/bin:")
  end
end
