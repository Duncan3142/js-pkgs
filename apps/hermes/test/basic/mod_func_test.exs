defmodule Basic.MyMod.Test do
  use ExUnit.Case, async: true

  test "zero?" do
    assert Basic.MyMod.zero?(0) == true
    assert Basic.MyMod.zero?(+0.0) == true
    assert Basic.MyMod.zero?(-0.0) == true
    assert Basic.MyMod.zero?(1) == false
    assert Basic.MyMod.zero?(1.0) == false
  end
end

defmodule Basic.Concat.Test do
  use ExUnit.Case, async: true

  test "join" do
    assert Basic.Concat.join("hello") == "hello"
    assert Basic.Concat.join("hello", "world") == "hello world"
    assert Basic.Concat.join("hello", "world", ",") == "hello,world"
  end
end
