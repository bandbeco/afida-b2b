class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders
  has_many :addresses, dependent: :destroy
  has_many :price_list_items, dependent: :destroy

  def formatted_name
    "#{first_name} #{last_name}".strip
  end

  def role
  end
end
