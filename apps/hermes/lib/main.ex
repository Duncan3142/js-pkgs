defprotocol Ingredient do
  def name(value)
end

defimpl Ingredient, for: MacroNutrients do
  def name(value), do: value.ingredient
end

defimpl String.Chars, for: MacroNutrients do
  def to_string(value), do: inspect(value)
end

mn = %MacroNutrients{ingredient: "butter", fat: 100}

IO.puts(mn)
IO.puts(Ingredient.name(mn))
