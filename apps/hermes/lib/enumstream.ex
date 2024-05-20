stream = File.stream!(File.cwd!() <> "/lib/enumstream.ex")
IO.puts(Enum.take(stream, 2))
