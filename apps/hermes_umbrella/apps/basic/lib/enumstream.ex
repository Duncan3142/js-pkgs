defmodule Basic.Enumstream do
  @moduledoc """
  Enum stream.
  """
  def stream do
    stream = File.stream!(File.cwd!() <> "/lib/enumstream.ex")
    Enum.take(stream, 2)
  end
end
