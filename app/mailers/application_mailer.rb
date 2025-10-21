# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("hello@afida.com", "Afida Team")
  layout "mailer"
end
