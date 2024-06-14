class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true

  validates :total_amount, presence: true, numericality: { greater_than: 0 }, if: :last_step?
  validates :shipping_address, presence: true, if: :shipping?
  validates :billing_address, presence: true, if: :billing?

  enum status: { pending: 0, processing: 1, shipped: 2, delivered: 3, canceled: 4 }

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda { |attributes| attributes['quantity'].to_i.zero? || attributes['quantity'].blank? }

  attr_writer :current_step

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[shopping shipping billing confirmation]
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

  def shopping?
    current_step == 'shopping'
  end

  def shipping?
    current_step == 'shipping'
  end

  def billing?
    current_step == 'billing'
  end

  def confirmation?
    current_step == 'confirmation'
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end
end
