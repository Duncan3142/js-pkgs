defmodule Basic.Basic do
  def put_strings do
    IO.puts(String.codepoints("👩‍🚒"))
    IO.puts(String.graphemes("👩‍🚒"))
    IO.puts(inspect([60, 61, 62], charlists: :as_lists))
  end
end
