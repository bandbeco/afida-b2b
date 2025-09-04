# frozen_string_literal: true

require 'test_helper'

class AbilityTest < ActionDispatch::IntegrationTest
  test 'user can only see their own order' do
    user = users(:one)
    order = orders(:one)
    order.user = user
    order.save
    ability = Ability.new(user)

    assert ability.can?(:read, order)
    assert ability.cannot?(:read, Order.new)
  end

  test 'user can see their own price list item' do
    user = users(:one)
    price_list_item = price_list_items(:one)
    price_list_item.user = user
    price_list_item.save
    ability = Ability.new(user)

    assert ability.can?(:read, price_list_item)
  end

  test 'user can create orders' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.can?(:create, Order)
  end

  test 'user can manage their own addresses' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.can?(:manage, user.addresses.build)
  end

  test 'user cannot manage someone elses addresses' do
    user = users(:one)
    other_user = users(:two)
    ability = Ability.new(user)

    assert ability.can?(:manage, user.addresses.build)
    assert ability.cannot?(:manage, other_user.addresses.build)
  end

  test 'user can see their own user profile' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.can?(:show, user)
  end

  test 'user cannot see another user profile' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.cannot?(:show, User.new)
  end

  test 'user cannot see list of all users' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.cannot?(:index, User)
  end

  test 'user can update their own user profile' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.can?(:update, user)
  end

  test 'user cannot see other users' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.cannot?(:read, User.new)
  end

  test 'admin can see all orders' do
    user = users(:admin)
    order = orders(:one)
    ability = Ability.new(user)

    assert ability.can?(:read, order)
    assert ability.can?(:read, Order.new)
  end

  test 'user can see the list of their own shopping cart items' do
    user = users(:one)
    cart = shopping_carts(:one)
    cart.user = user
    cart.save
    item = cart.shopping_cart_items.create(product: products(:one), unit_price: 1)

    ability = Ability.new(user)

    assert ability.can?(:read, item)
  end

  test 'user can add item to cart' do
    user = users(:one)
    cart = shopping_carts(:one)
    cart.user = user
    cart.save
    item = cart.shopping_cart_items.create(product: products(:one), unit_price: 1)

    ability = Ability.new(user)

    assert ability.can?(:add_to_cart, item)
  end
end
