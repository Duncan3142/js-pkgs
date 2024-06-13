defmodule Basic.Enumstream.Test do
  use ExUnit.Case, async: true

  test "stream" do
    assert Basic.Enumstream.stream() == [
             "defmodule Basic.Enumstream do\n",
             "  def stream do\n"
           ]
  end
end
