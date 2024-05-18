defmodule MyMod do
  @spec func() :: :ok
  def func do
    priv()
    IO.puts("Hello from MyMod.func")
  end

  defp priv do
    IO.puts("Hello from MyMod.priv")
  end

  @spec zero?(number()) :: boolean()
  def zero?(0), do: true
  def zero?(0.0), do: true
  def zero?(x) when is_integer(x), do: false
  def zero?(x) when is_float(x), do: false
end

MyMod.func()
IO.puts(MyMod.zero?(0))
IO.puts(MyMod.zero?(0.0))
IO.puts(MyMod.zero?(-0.0))
IO.puts(MyMod.zero?(1))
IO.puts(MyMod.zero?(1.0))
