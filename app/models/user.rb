class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :validatable, :invitable

  validates_confirmation_of :password

  has_one :shopping_cart, dependent: :destroy
  has_many :shopping_cart_items, through: :shopping_cart

  has_many :orders
  has_many :addresses, dependent: :destroy
  has_many :price_list_items, dependent: :destroy

  accepts_nested_attributes_for :price_list_items, allow_destroy: true

  enum role: { customer: 0, admin: 1 }

  delegate :can?, :cannot?, to: :ability

  def formatted_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == 'admin'
  end

  def customer?
    role == 'customer'
  end

  def invited?
    invitation_sent_at.present?
  end

  def accepted_invitation?
    invitation_accepted_at.present?
  end

  protected

  def password_required? 
    false 
  end
end
