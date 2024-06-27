class Address < ApplicationRecord
  belongs_to :user

  def formatted_address
    "#{user.formatted_name}, #{building_name}, #{street_number_and_name}, #{post_town}, #{postcode}"
  end
end
