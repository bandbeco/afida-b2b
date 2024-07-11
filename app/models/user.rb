class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :validatable, :invitable

  has_many :orders
  has_many :addresses, dependent: :destroy
  has_many :price_list_items, dependent: :destroy

  enum role: { customer: 0, admin: 1 }

  delegate :can?, :cannot?, to: :ability

  def formatted_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == 'admin'
  end

  def customer?
    role == 'customer'
  end

  def invited?
    invitation_sent_at.present?
  end

  def accepted_invitation?
    invitation_accepted_at.present?
  end

  protected

  def password_required? 
    false 
  end
end
