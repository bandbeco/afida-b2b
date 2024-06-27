require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { colour: @product.colour, description: @product.description, height_in_mm: @product.height_in_mm, name: @product.name, pac_size: @product.pac_size, price: @product.price, sku: @product.sku, width_in_mm: @product.width_in_mm } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { colour: @product.colour, description: @product.description, height_in_mm: @product.height_in_mm, name: @product.name, pac_size: @product.pac_size, price: @product.price, sku: @product.sku, width_in_mm: @product.width_in_mm } }
    assert_redirected_to product_url(@product)
  end

  test "should soft delete product" do
    delete product_url(@product)
    assert_not(@product.reload.deleted_at.nil?)

    assert_redirected_to products_url
  end
end
