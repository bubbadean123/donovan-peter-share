require 'test/unit'
require "../models/recipe"

INGREDIENT_COSTS = {"foo" => 0.5, "bar" => 1.0}

class RecipeTest < Test::Unit::TestCase
  def test_creates_new_recipe
    r = Recipe.new("test recipe", {"foo" => 1, "bar" => 1})
    assert r
  end

  def test_validates_ingredients
    assert_raises Recipe::Invalid do
      Recipe.new("test recipe", {"not found" => 1})
    end
  end

  def test_calculates_cost
    r = Recipe.new("test recipe", {"foo" => 1, "bar" => 1})
    assert_equal 1.5, r.cost
  end

  def test_calculates_cost_with_mixed_quantity_ingredients
    r = Recipe.new("test recipe", {"foo" => 3, "bar" => 2})
    assert_equal 3.5, r.cost
  end

  def test_requirement
    r = Recipe.new("test recipe", {"foo" => 3, "bar" => 2})
    assert_equal 3, r.requirement('foo')
  end

  def test_requirement_for_missing_ingredient
    r = Recipe.new("test recipe", {"foo" => 3, "bar" => 2})
    assert_equal 0, r.requirement('not found')
  end
end