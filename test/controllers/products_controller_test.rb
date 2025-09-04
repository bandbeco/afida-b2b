# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:admin)
    @product = products(:one)
  end

  test 'should get index' do
    get products_url
    assert_response :success
  end

  test 'should get new' do
    get new_product_url
    assert_response :success
  end

  test 'should create product' do
    params = {
      product: {
        colour: @product.colour,
        description: @product.description,
        height_in_mm: @product.height_in_mm,
        name: @product.name,
        pac_size: @product.pac_size,
        price: 100,
        sku: @product.sku,
        width_in_mm: @product.width_in_mm,
        category_id: @product.category_id
      }
    }

    post products_url, params: params

    assert_redirected_to product_url(Product.last)
  end

  test 'should create as many price list items as there are users' do
    params = {
      product: {
        colour: @product.colour,
        description: @product.description,
        height_in_mm: @product.height_in_mm,
        name: @product.name,
        pac_size: @product.pac_size,
        price: 100,
        sku: @product.sku,
        width_in_mm: @product.width_in_mm,
        category_id: @product.category_id
      }
    }

    assert_difference 'PriceListItem.count', User.count do
      post products_url, params: params
    end
  end

  test 'should show product' do
    get product_url(@product)
    assert_response :success
  end

  test 'should get edit' do
    get edit_product_url(@product)
    assert_response :success
  end

  test 'should update product' do
    params = {
      product: {
        colour: @product.colour,
        description: @product.description,
        height_in_mm: @product.height_in_mm,
        name: @product.name,
        pac_size: @product.pac_size,
        price: 100,
        sku: @product.sku,
        width_in_mm: @product.width_in_mm,
        category_id: @product.category_id
      }
    }

    patch product_url(@product), params: params

    assert_redirected_to products_url
  end

  test 'should soft delete product' do
    delete product_url(@product)
    assert_not(@product.reload.deleted_at.nil?)

    assert_redirected_to products_url
  end
end
