# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :read, Order, user: user
    can :read, PriceListItem, user: user
    can %i[read add_to_cart remove_from_cart], ShoppingCartItem, shopping_cart: { user: user }
    can :create, Order
    can %i[show update], User, id: user.id
    can :manage, Address, user_id: user.id

    return unless user.admin?

    can :manage, :all
  end
end
