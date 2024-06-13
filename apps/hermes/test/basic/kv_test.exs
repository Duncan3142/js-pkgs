defmodule Basic.KV.Test do
  use ExUnit.Case, async: true

  test "KV" do
    Basic.KV.new(:kv)
    :kv |> Basic.KV.set(:hello, "world")
    :kv |> Basic.KV.set(:meow, "meow")
    :kv |> Basic.KV.set(:one, 1)

    v = :kv |> Basic.KV.get(:hello)
    assert v == "world"
    v = :kv |> Basic.KV.get(:meow)
    assert v == "meow"
    v = :kv |> Basic.KV.get(:one)
    assert v == 1
  end

  test "write" do
    pid =
      spawn(fn ->
        receive do
          {type, from, reply_as, req} ->
            {_, _, msg} = req
            send(from, {:right_write, type, msg})
            send(from, {:io_reply, reply_as, :ok})
        end
      end)

    IO.write(pid, "hello")

    assert_receive {:right_write, :io_request, "hello"}, 1000
  end
end
