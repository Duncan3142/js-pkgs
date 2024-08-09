excluded = if Node.alive?, do: [], else: [:distributed]

ExUnit.start(exclude: excluded)
