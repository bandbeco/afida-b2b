# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :validatable, :invitable

  validates :password, confirmation: true

  has_one :shopping_cart, dependent: :destroy
  has_many :shopping_cart_items, through: :shopping_cart
  has_many :orders, dependent: :destroy
  has_many :price_list_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  belongs_to :default_shipping_address, class_name: "Address",
                                        optional: true
  belongs_to :default_billing_address, class_name: "Address", optional: true

  accepts_nested_attributes_for :price_list_items, allow_destroy: true

  enum :role, { customer: 0, admin: 1 }

  delegate :can?, :cannot?, to: :ability

  def formatted_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == "admin"
  end

  def customer?
    role == "customer"
  end

  def invited?
    invitation_sent_at.present?
  end

  def accepted_invitation?
    invitation_accepted_at.present?
  end

  def most_ordered_products(limit = 3)
    return [] if orders.empty?

    product_data = OrderItem
                   .joins(:order, :product)
                   .where(orders: { user_id: id })
                   .group("products.id")
                   .select(
                     "products.id as product_id",
                     "COUNT(DISTINCT orders.id) as frequency",
                     "SUM(order_items.quantity) as total_quantity"
                   )
                   .order(frequency: :desc)
                   .limit(limit)

    product_data.map do |record|
      {
        product: Product.find(record.product_id),
        frequency: record.frequency,
        total_quantity: record.total_quantity
      }
    end
  end

  protected

  def password_required?
    false
  end
end
