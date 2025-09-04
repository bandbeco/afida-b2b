# frozen_string_literal: true

class PriceListItem < ApplicationRecord
  default_scope do
    where(deleted_at: nil)
      .order(created_at: :asc)
  end

  scope :with_deleted, -> { unscope(where: :deleted_at) }
  scope :without_hidden, -> { where(hidden: false) }

  belongs_to :user
  belongs_to :product

  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def soft_delete!
    update!(deleted_at: Time.zone.now)
  end

  def category
    product.category
  end
end
