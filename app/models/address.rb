# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :street_number_and_name, presence: true
  validates :post_town, presence: true
  validates :postcode, presence: true

  validates :company, presence: true
  validates :attn, presence: true

  def formatted_address(include_attn: true)
    parts = [
      (attn if include_attn),
      company,
      building_name,
      street_number_and_name,
      post_town,
      postcode
    ]
    parts.compact_blank.join(', ')
  end
end
