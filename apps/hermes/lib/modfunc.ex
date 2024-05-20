defmodule MyMod do
  @spec func() :: :ok
  def func do
    priv()
    priv("G'day")
    IO.puts("Hello from MyMod.func")
  end

  defp priv(greeting \\ "Hello") do
    IO.puts("#{greeting} from MyMod.priv")
  end

  @spec zero?(number()) :: boolean()
  def zero?(0), do: true
  def zero?(+0.0), do: true
  def zero?(-0.0), do: true
  def zero?(x) when is_integer(x), do: false
  def zero?(x) when is_float(x), do: false
end

defmodule Concat do
  # A function head declaring defaults

  def join(a) do
    a
  end

  def join(a, b, sep \\ " ") do
    a <> sep <> b
  end
end

MyMod.func()
IO.puts(MyMod.zero?(0))
IO.puts(MyMod.zero?(0.0))
IO.puts(MyMod.zero?(-0.0))
IO.puts(MyMod.zero?(1))
IO.puts(MyMod.zero?(1.0))
