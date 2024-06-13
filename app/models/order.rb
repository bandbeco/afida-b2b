class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :order_status, presence: true
  validates :shipping_address, presence: true
  validates :billing_address, presence: true
  validates :payment_method, presence: true

  enum status: { pending: 0, processing: 1, shipped: 2, delivered: 3, canceled: 4 }
end