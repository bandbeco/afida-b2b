# frozen_string_literal: true

module ApplicationHelper
  def currency_for(amount)
    number_to_currency(amount, locale: :en)
  end
end
