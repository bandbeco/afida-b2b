# frozen_string_literal: true

require 'application_system_test_case'

class ShoppingCartsTest < ApplicationSystemTestCase
  setup do
    @shopping_cart = shopping_carts(:one)
  end

  test 'visiting the index' do
    visit shopping_carts_url
    assert_selector 'h1', text: 'Shopping carts'
  end

  test 'should create shopping cart' do
    visit shopping_carts_url
    click_on 'New shopping cart'

    fill_in 'User', with: @shopping_cart.user_id
    click_on 'Create Shopping cart'

    assert_text 'Shopping cart was successfully created'
    click_on 'Back'
  end

  test 'should update Shopping cart' do
    visit shopping_cart_url(@shopping_cart)
    click_on 'Edit this shopping cart', match: :first

    fill_in 'User', with: @shopping_cart.user_id
    click_on 'Update Shopping cart'

    assert_text 'Shopping cart was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Shopping cart' do
    visit shopping_cart_url(@shopping_cart)
    click_on 'Destroy this shopping cart', match: :first

    assert_text 'Shopping cart was successfully destroyed'
  end
end
