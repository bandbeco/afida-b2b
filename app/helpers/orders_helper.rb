module OrdersHelper
  def user_addresses
    current_user.addresses.map do |address|
      [
        address.formatted_address,
        address.formatted_address
      ]
    end
  end
end
