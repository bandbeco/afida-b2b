require "test_helper"

class ShoppingCartItemTest < ActiveSupport::TestCase
  setup do
    @shopping_cart = shopping_carts(:one)
    @product = products(:one)
  end

  test "should be valid with valid attributes" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 1,
      unit_price: 10.0
    )
    assert item.valid?
  end

  test "should not be valid without quantity" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: nil,
      unit_price: 10.0
    )
    assert_not item.valid?
  end

  test "should not be valid with negative quantity" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: -1,
      unit_price: 10.0
    )
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be greater than or equal to 0"
  end

  test "should not be valid without unit price" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 1,
      unit_price: nil
    )
    assert_not item.valid?
    assert_includes item.errors[:unit_price], "can't be blank"
  end

  test "should belong to a shopping cart" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 1,
      unit_price: 10.0
    )
    assert_respond_to item, :shopping_cart
  end

  test "should belong to a product" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 1,
      unit_price: 10.0
    )
    assert_respond_to item, :product
  end

  test "total_price should calculate correctly" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 3,
      unit_price: 10.50
    )
    assert_equal 31.50, item.total_price
  end

  test "total_price should round to 2 decimal places" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 3,
      unit_price: 10.51
    )
    assert_equal 31.53, item.total_price
  end

  test "added_to_cart scope should only return items with quantity greater than 0" do
    item1 = shopping_cart_items(:one)
    item1.update(quantity: 0)
    item2 = shopping_cart_items(:two)
    item2.update(quantity: 5)

    assert_equal [item2], ShoppingCartItem.added_to_cart
  end

  test "attributes should return expected hash" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 2,
      unit_price: 10.0
    )
    expected = {
      product_id: @product.id,
      quantity: 2,
      unit_price: 10.0
    }
    assert_equal expected, item.attributes
  end

  test "should calculate total price correctly" do
    item = ShoppingCartItem.new(
      shopping_cart: @shopping_cart,
      product: @product,
      quantity: 2,
      unit_price: 10.0
    )
    assert_equal 20.0, item.total_price
  end
end
