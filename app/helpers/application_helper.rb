module ApplicationHelper
  def currency_for(amount)
    number_to_currency(amount, locale: :gb)
  end
end
