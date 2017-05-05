require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'new user have a deck' do
    FactoryGirl.create_list(:card, 30)
    user = create(:user)
    assert_not_empty(user.deck)
  end
end
