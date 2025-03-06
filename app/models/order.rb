class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates_associated :order_items
  validates_presence_of :order_items

  validates :subtotal_amount, presence: true, numericality: { greater_than: 0 }
  validates :shipping_address, :billing_address, :payment_method, :status, presence: true

  enum :status, [:pending, :processing, :shipped, :delivered, :canceled]
  enum :payment_method, [:invoice, :bank_transfer, :credit_card]

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda { |attributes| attributes['quantity'].to_i.zero? || attributes['quantity'].blank? }

  after_create :generate_invoice_number

  private

  def generate_invoice_number
    update(invoice_number: "ONL-000#{id}")
  end
end
