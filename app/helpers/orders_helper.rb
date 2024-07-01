module OrdersHelper
  def user_addresses
    current_user.addresses.map do |address|
      [
        address.formatted_address,
        address.formatted_address
      ]
    end
  end

  def currency_for(amount)
    number_to_currency(amount, locale: :gb)
  end
end
