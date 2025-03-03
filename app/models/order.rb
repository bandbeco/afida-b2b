class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates_associated :order_items
  validates_presence_of :order_items

  validates :subtotal_amount, presence: true, numericality: { greater_than: 0 }, if: :last_step?
  validates :shipping_address, presence: true, if: :last_step?
  validates :billing_address, presence: true, if: :last_step?
  validates :payment_method, presence: true, if: :last_step?


  enum :status, [:pending, :processing, :shipped, :delivered, :canceled]
  enum :payment_method, [:invoice, :bank_transfer, :credit_card]

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda { |attributes| attributes['quantity'].to_i.zero? || attributes['quantity'].blank? }

  attr_writer :current_step

  VAT_RATE = 0.20

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[shopping confirmation]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step) - 1]
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def formatted_order_id
    "INV-000#{id}"
  end

  private

  def shopping?
    current_step == 'shopping'
  end

  def confirmation?
    current_step == 'confirmation'
  end
end
