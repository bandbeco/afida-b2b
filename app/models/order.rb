# frozen_string_literal: true

class Order < ApplicationRecord
  # For form handling
  attr_accessor :selected_shipping_address_id, :selected_billing_address_id, :use_shipping_for_billing
  attr_accessor :shipping_company, :shipping_attn, :shipping_building_name, :shipping_street_number_and_name,
                :shipping_post_town, :shipping_postcode, :shipping_additional_notes,
                :billing_company, :billing_attn, :billing_building_name, :billing_street_number_and_name,
                :billing_post_town, :billing_postcode, :billing_additional_notes,
                :save_shipping_address, :save_billing_address

  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates_associated :order_items
  validates :order_items, presence: true
  validates :shipping_address, :billing_address, presence: true

  validates :subtotal_amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, :status, presence: true

  enum :status, { pending: 0, processing: 1, shipped: 2, delivered: 3, canceled: 4 }
  enum :payment_method, { invoice: 0, bank_transfer: 1, credit_card: 2 }

  scope :revenue_in_range, ->(range) { where(created_at: range).sum(:total_amount) }
  scope :count_in_range, ->(range) { where(created_at: range).count }

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda { |attributes|
    attributes["quantity"].to_i.zero? || attributes["quantity"].blank?
  }

  before_validation :build_address_strings, on: :create

  after_create :generate_invoice_number

  private

  def build_address_strings
    # Build shipping address string
    shipping_attrs = {}.tap do |attrs|
      attrs[:company] = shipping_company
      attrs[:attn] = shipping_attn
      attrs[:building_name] = shipping_building_name
      attrs[:street_number_and_name] = shipping_street_number_and_name
      attrs[:post_town] = shipping_post_town
      attrs[:postcode] = shipping_postcode
      attrs[:additional_notes] = shipping_additional_notes
    end
    if shipping_attrs.compact_blank.any?
      self.shipping_address = Address.new(shipping_attrs.compact_blank).formatted_address(include_attn: true)
    end

    # Build billing address string
    billing_attrs = {}.tap do |attrs|
      attrs[:company] = billing_company
      attrs[:attn] = billing_attn # Billing usually doesn't need Attn?
      attrs[:building_name] = billing_building_name
      attrs[:street_number_and_name] = billing_street_number_and_name
      attrs[:post_town] = billing_post_town
      attrs[:postcode] = billing_postcode
      attrs[:additional_notes] = billing_additional_notes
    end
    # If using shipping address, copy the already built string
    if use_shipping_for_billing == "1"
      self.billing_address = shipping_address
    elsif billing_attrs.compact_blank.any?
      self.billing_address = Address.new(billing_attrs.compact_blank).formatted_address(include_attn: false)
    end

    # Add validation for the built strings if needed now
    errors.add(:shipping_address, :blank) if shipping_address.blank?
    errors.add(:billing_address, :blank) if billing_address.blank?
  end

  def generate_invoice_number
    update(invoice_number: "ONL-000#{id}")
  end
end
