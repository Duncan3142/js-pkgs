defmodule MyModAttr do
  @sha System.cmd("git", ["rev-parse", "HEAD"]) |> elem(0) |> String.trim()
  def sha do
    IO.puts(@sha)
    IO.puts(System.get_env("PATH"))
  end
end

MyModAttr.sha()
