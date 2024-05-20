send(self(), {:hello, "world"})
send(self(), {:meow, "meow"})
send(self(), 0)

spawn(fn -> raise "oops" end)

Task.start(fn -> raise "darn" end)

receive do
  {:hello, msg} -> IO.puts(msg)
  {:meow, msg} -> IO.puts(String.upcase(msg))
  _ -> IO.puts(:no_match)
end

receive do
  {:hello, msg} -> IO.puts(msg)
  {:meow, msg} -> IO.puts(String.upcase(msg))
  _ -> IO.puts(:no_match)
end

receive do
  {:hello, msg} -> IO.puts(msg)
  {:meow, msg} -> IO.puts(String.upcase(msg))
  _ -> IO.puts(:no_match)
end

parent = self()
spawn(fn -> send(parent, {:hello, self()}) end)

receive do
  {:hello, pid} -> IO.puts("Got hello from #{inspect(pid)}")
end
