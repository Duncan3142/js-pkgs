stream = File.stream!(File.cwd!() <> "/lib/basic/enumstream.ex")
IO.puts(Enum.take(stream, 2))
