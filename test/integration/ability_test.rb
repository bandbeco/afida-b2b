require "test_helper"

class AbilityTest < ActionDispatch::IntegrationTest
  test 'user can only see their own orders' do
    user = users(:one)
    order = orders(:one)
    order.user = user
    order.save
    ability = Ability.new(user)

    assert ability.can?(:read, order)
    assert ability.cannot?(:read, Order.new)
  end

  test 'user can create orders' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.can?(:create, Order)
  end

  test 'user can see their own user profile' do
    user = users(:one)
    ability = Ability.new(user)

    assert ability.can?(:show, user)
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
end
