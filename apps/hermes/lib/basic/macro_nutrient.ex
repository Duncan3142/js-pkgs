defmodule Basic.MacroNutrients do
  @enforce_keys [:ingredient]
  defstruct [:ingredient, fat: 0, protein: 0, carbs: 0, fiber: 0, salt: 0]
end
