max = 8

case {1, 2} do
  {x, _} when x < max -> IO.puts("x is less than #{max}")
end

cond do
  1 + 1 == 2 -> IO.puts("1 + 1 == 2")
  1 + 1 == 3 -> IO.puts("1 + 1 == 3")
end
