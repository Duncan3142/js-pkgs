defmodule Basic.Enumstream do
  def stream do
    stream = File.stream!(File.cwd!() <> "/lib/basic/enumstream.ex")
    Enum.take(stream, 2)
  end
end
