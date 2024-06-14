class Product < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  def soft_delete
    update(deleted_at: Time.zone.now)
  end
end
