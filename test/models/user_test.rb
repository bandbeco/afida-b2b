# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#formatted_name' do
    user = users(:one)
    assert_equal 'John Doe', user.formatted_name
  end

  test '#admin?' do
    user = users(:admin)
    assert user.admin?
  end

  test '#customer?' do
    user = users(:one)
    assert user.customer?
  end
end
