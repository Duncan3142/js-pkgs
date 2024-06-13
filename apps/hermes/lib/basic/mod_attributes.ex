defmodule Basic.ModAttr do
  @sha System.cmd("git", ["rev-parse", "HEAD"]) |> elem(0) |> String.trim()
  def sha do
    @sha
  end

  def path do
    System.get_env("PATH")
  end
end
