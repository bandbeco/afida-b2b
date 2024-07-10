# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :read, Order, user: user
    can :create, Order
    can [:show, :update], User, id: user.id

    return unless user.admin?

    can :manage, :all
  end
end
