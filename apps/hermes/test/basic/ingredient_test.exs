defmodule Basic.IngredientTest do
  use ExUnit.Case, async: true

  test "name" do
    mn = %Basic.MacroNutrients{ingredient: "butter", fat: 100}

    assert Basic.Ingredient.name(mn) == "butter"

    assert to_string(mn) ==
             "%Basic.MacroNutrients{ingredient: \"butter\", fat: 100, protein: 0, carbs: 0, fiber: 0, salt: 0}"
  end
end
