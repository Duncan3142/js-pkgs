max = 8

case {1, 2} do
  {x, _} when x < max -> IO.puts("x is less than #{max}")
end

cond do
  1 + 1 == 2 -> IO.puts("1 + 1 == 2")
  1 + 1 == 3 -> IO.puts("1 + 1 == 3")
end

b =
  if 1 + 1 == 3 do
    max = max + 1
    IO.puts("max is #{max}")
    max
  else
    max = max - 1
    IO.puts("max is #{max}")
    max
  end

IO.puts("b is #{b}")
IO.puts("max is #{max}")

sub = fn a, b -> a - b end

IO.puts("sub(5, 3) is #{sub.(5, 3)}")

x = 4 |> sub.(1)

IO.puts("x is #{x}")

short = &(&1 * 2)

IO.puts("short(3) is #{short.(3)}")

IO.puts(String.codepoints("👩‍🚒"))
IO.puts(String.graphemes("👩‍🚒"))
inspect([60, 61, 62], charlists: :as_lists)
