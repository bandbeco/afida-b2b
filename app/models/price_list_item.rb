class PriceListItem < ApplicationRecord
  default_scope do
    where(deleted_at: nil, hidden: false)
      .order(created_at: :asc)
  end

  scope :with_deleted, -> { unscope(where: :deleted_at) }
  scope :with_hidden, -> { unscope(where: :hidden) }

  belongs_to :user
  belongs_to :product

  validates :price, numericality: { greater_than: 0 }, allow_nil: true

  def soft_delete!
    update!(deleted_at: Time.zone.now)
  end

  def category
    product.category
  end
end
