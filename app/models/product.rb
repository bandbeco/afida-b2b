class Product < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  belongs_to :category, optional: true

  has_many :orders, through: :order_items 
  has_many :order_items, dependent: :destroy
  has_many :price_list_items

  has_one_attached :picture

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  def soft_delete!
    update!(deleted_at: Time.zone.now)
  end
end
