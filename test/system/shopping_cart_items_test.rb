# frozen_string_literal: true

require 'application_system_test_case'

class ShoppingCartItemsTest < ApplicationSystemTestCase
  setup do
    @shopping_cart_item = shopping_cart_items(:one)
  end

  test 'visiting the index' do
    visit shopping_cart_items_url
    assert_selector 'h1', text: 'Shopping cart items'
  end

  test 'should create shopping cart item' do
    visit shopping_cart_items_url
    click_on 'New shopping cart item'

    fill_in 'Cart', with: @shopping_cart_item.cart_id
    fill_in 'Product', with: @shopping_cart_item.product_id
    fill_in 'Quantity', with: @shopping_cart_item.quantity
    click_on 'Create Shopping cart item'

    assert_text 'Shopping cart item was successfully created'
    click_on 'Back'
  end

  test 'should update Shopping cart item' do
    visit shopping_cart_item_url(@shopping_cart_item)
    click_on 'Edit this shopping cart item', match: :first

    fill_in 'Cart', with: @shopping_cart_item.cart_id
    fill_in 'Product', with: @shopping_cart_item.product_id
    fill_in 'Quantity', with: @shopping_cart_item.quantity
    click_on 'Update Shopping cart item'

    assert_text 'Shopping cart item was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Shopping cart item' do
    visit shopping_cart_item_url(@shopping_cart_item)
    click_on 'Destroy this shopping cart item', match: :first

    assert_text 'Shopping cart item was successfully destroyed'
  end
end
