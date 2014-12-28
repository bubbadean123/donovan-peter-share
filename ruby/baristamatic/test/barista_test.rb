require 'test/unit'
require_relative "../models/barista"

INGREDIENT_COSTS = {"foo" => 0.5, "bar" => 1.0}

class BaristaTest < Test::Unit::TestCase
  def setup
    Barista.restock
    Barista.set_menu({
      "foobar" => {"foo" => 2, "bar" => 3}, # 1
      "out of stock" => { "foo" => 3, "bar" => 1000000000000} # 2
    })
  end

  def test_restore_stock_when_restocking
    Barista.inventory = {}
    Barista.restock
    inventory = Barista.inventory
    assert_equal 9999999, inventory['foo']
    assert_equal 9999999, inventory['bar']
  end

  def test_restock_initializes_inventory
    Barista.inventory = nil
    Barista.restock
    inventory = Barista.inventory
    assert_equal 9999999, inventory['foo']
    assert_equal 9999999, inventory['bar']
  end

  def test_make_a_drink_returns_false_if_drink_is_out_of_range
    assert_equal [nil, false], Barista.make_drink(1000)
  end

  def test_make_a_drink_returns_false_if_drink_is_zero
    assert_equal [nil, false], Barista.make_drink(0)
  end

  def test_make_a_drink_reduces_inventory
    Barista.restock
    Barista.make_drink(1)
    assert_equal({"foo" => 9999997, "bar" => 9999996}, Barista.inventory)
  end

  def test_make_a_drink_returns_true
    Barista.restock
    assert Barista.make_drink(1)
  end

  def test_make_a_drink_when_out_of_stock_returns_false
    Barista.restock
    assert_equal [Barista.menu[1], false], Barista.make_drink(2)
  end

  def test_make_a_drink_when_out_of_stock_does_not_affect_inventory
    Barista.restock
    Barista.make_drink(2)
    assert_equal({"foo" => 9999999, "bar" => 9999999}, Barista.inventory)
  end

  def test_in_stock_returns_true_if_in_stock
    Barista.restock
    assert Barista.in_stock?(Recipe.new("foobar", {"foo" => 2, "bar" => 3}))
  end

  def test_in_stock_returns_false_if_not_in_stock
    Barista.restock
    assert !Barista.in_stock?(Recipe.new("out of stock", { "foo" => 3, "bar" => 1000000000000}))
  end

  def test_set_menu_creates_recipe_list_in_alpha_order
    Barista.set_menu({'B' => {'foo' => 1}, 'C' => {'foo' => 1}, 'A' => {'foo' => 1}})
    assert_equal(['A', 'B', 'C'], Barista.menu.map{|r| r.name})
  end
end