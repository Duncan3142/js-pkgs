defmodule Basic.Basic.Test do
  @max 8

  use ExUnit.Case, async: true

  test "case" do
    m =
      case {1, 2} do
        {x, _} when x < @max -> "x is less than #{@max}"
      end

    assert m == "x is less than 8"
  end

  test "cond" do
    m =
      cond do
        1 + 1 == 2 -> "1 + 1 == 2"
        1 + 1 == 3 -> "1 + 1 == 3"
      end

    assert m == "1 + 1 == 2"
  end

  test "if" do
    v =
      if 1 + 1 == 3 do
        @max + 1
      else
        @max - 1
      end

    assert v == 7
  end

  test "fn" do
    sub = fn a, b -> a - b end

    m = "sub(5, 3) is #{sub.(5, 3)}"

    assert m == "sub(5, 3) is 2"

    x = 4 |> sub.(1)

    assert x == 3
  end

  test "short" do
    short = &(&1 * 2)

    assert short.(3) == 6
  end
end
