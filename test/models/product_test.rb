# frozen_string_literal: true

require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = Product.new(
      name: "Eco Box",
      sku: "ECO-001",
      price: 5.99,
      category: categories(:one)
    )
  end

  # Validations
  test "valid product" do
    assert @product.valid?
  end

  test "requires name" do
    @product.name = nil
    assert_not @product.valid?
    assert_includes @product.errors[:name], "can't be blank"
  end

  test "requires price" do
    @product.name = "Test Product"
    @product.price = nil
    assert_not @product.valid?
    assert_includes @product.errors[:price], "can't be blank"
  end

  test "price must be numeric" do
    @product.price = "free"
    assert_not @product.valid?
  end

  test "price must be greater than or equal to zero" do
    @product.price = -10
    assert_not @product.valid?
    assert_includes @product.errors[:price], "must be greater than or equal to 0"
  end

  test "allows zero price" do
    @product.price = 0
    assert @product.valid?
  end

  test "allows positive price" do
    @product.price = 99.99
    assert @product.valid?
  end

  # Associations
  test "belongs to category" do
    assert_respond_to @product, :category
  end

  test "has many order items" do
    assert_respond_to @product, :order_items
  end

  test "has many orders through order items" do
    assert_respond_to @product, :orders
  end

  test "has many price list items" do
    assert_respond_to @product, :price_list_items
  end

  test "has many shopping cart items" do
    assert_respond_to @product, :shopping_cart_items
  end

  test "has one attached picture" do
    assert_respond_to @product, :picture
  end

  # Soft deletion
  test "soft_delete! sets deleted_at timestamp" do
    @product.save!
    assert_nil @product.deleted_at

    @product.soft_delete!
    assert_not_nil @product.deleted_at
  end

  test "default scope excludes soft deleted products" do
    @product.save!
    original_id = @product.id

    @product.soft_delete!

    assert_nil Product.find_by(id: original_id)
  end

  test "with_deleted scope includes soft deleted products" do
    @product.save!
    original_id = @product.id

    @product.soft_delete!

    assert_not_nil Product.with_deleted.find_by(id: original_id)
  end

  test "soft_delete! keeps product in database" do
    @product.save!
    original_id = @product.id

    @product.soft_delete!

    # Should exist with unscoped query
    assert Product.unscoped.exists?(original_id)
  end

  # Dependencies
  test "destroys dependent order items when destroyed" do
    @product.save!
    order = orders(:one)
    order.order_items.create!(
      product: @product,
      quantity: 1,
      unit_price: 10.0
    )

    assert_difference("OrderItem.count", -1) do
      @product.destroy
    end
  end

  test "destroys dependent price list items when destroyed" do
    @product.save!
    PriceListItem.create!(
      user: users(:one),
      product: @product,
      price: 8.99
    )

    assert_difference("PriceListItem.count", -1) do
      @product.destroy
    end
  end

  test "destroys dependent shopping cart items when destroyed" do
    @product.save!
    cart = ShoppingCart.create!(user: users(:one))
    cart.shopping_cart_items.create!(
      product: @product,
      quantity: 2,
      unit_price: 5.99
    )

    assert_difference("ShoppingCartItem.count", -1) do
      @product.destroy
    end
  end
end
