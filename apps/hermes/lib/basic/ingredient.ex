defprotocol Basic.Ingredient do
  def name(value)
end

defimpl Basic.Ingredient, for: Basic.MacroNutrients do
  def(name(value), do: value.ingredient)
end

defimpl String.Chars, for: Basic.MacroNutrients do
  def to_string(value), do: inspect(value)
end
