class PriceListItem < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  belongs_to :user
  belongs_to :product

  validates :price, numericality: { greater_than: 0 }

  def soft_delete!
    update!(deleted_at: Time.zone.now)
  end
end
