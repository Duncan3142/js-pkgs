# Keyword list

l = [meow: "meow", woof: "woof", moo: "moo"]

IO.puts(inspect(l))

# Map

m = %{meow: "meow", woof: "woof", moo: "moo"}

IO.puts("#{Map.get(m, :meow)} #{m[:woof]} #{m[:hiss]} done")
IO.puts(inspect(%{m | meow: "purr"}))

ml = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]

ml = put_in(ml[:mary].name, "Jane")

IO.puts(inspect(ml))

ml = put_in(ml, [:john, :age], 42)

IO.puts(inspect(ml))
