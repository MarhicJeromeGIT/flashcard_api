require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase
  def setup
    Rails.cache.clear
    clear_redis
    @user = create(:user)
  end

  test 'can add and fetch assessments from redis' do
    card_id = 1
    data = @user.data

    assert_equal([], data.card_assessments(card_id))
    data.add_assessment(card_id: card_id, elapsed_time: 1000, rating: 0)
    assessments = data.card_assessments(card_id)
    assert_equal(1, assessments.count)
  end

  test 'can add the same assessment multiple time' do
    data = @user.data
    data.add_assessment(card_id: 1, elapsed_time: 1000, rating: 1)
    data.add_assessment(card_id: 1, elapsed_time: 1000, rating: 1)
    data.add_assessment(card_id: 1, elapsed_time: 1000, rating: 1)
    assessments = data.card_assessments(1)
    assert_equal(3, assessments.count)
  end
end
