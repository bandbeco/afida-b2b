# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, Order, user: user
    can :read, PriceListItem, user: user
    can :create, Order
    can [:show, :update], User, id: user.id
    can :manage, Address, user_id: user.id

    return unless user.admin?

    can :manage, :all
  end
end
