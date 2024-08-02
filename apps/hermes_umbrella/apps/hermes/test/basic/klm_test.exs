defmodule Basic.KlMTest do
  use ExUnit.Case, async: true

  test "greets the world" do
    # Keyword list

    l = [meow: "meow", woof: "woof", moo: "moo"]

    assert l[:meow] == "meow"

    # Map

    m = %{meow: "meow", woof: "woof", moo: "moo"}

    assert "#{Map.get(m, :meow)} #{m[:woof]} #{m[:hiss]} done" == "meow woof  done"

    assert %{m | meow: "purr"} == %{meow: "purr", woof: "woof", moo: "moo"}

    ml = [
      john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
      mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
    ]

    ml = put_in(ml[:mary].name, "Jane")

    assert ml == [
             john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
             mary: %{name: "Jane", age: 29, languages: ["Elixir", "F#", "Clojure"]}
           ]

    ml = put_in(ml, [:john, :age], 42)

    assert ml == [
             john: %{name: "John", age: 42, languages: ["Erlang", "Ruby", "Elixir"]},
             mary: %{name: "Jane", age: 29, languages: ["Elixir", "F#", "Clojure"]}
           ]
  end
end
