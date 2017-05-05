require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase
  def setup
    Rails.cache.clear
    clear_redis
  end

  test 'can add and fetch assessments from redis' do
    user_id = 1
    card_id = 1
    assert_equal([], Assessment.get(user_id: user_id, card_id: card_id))
    Assessment.add(user_id: user_id, card_id: card_id, elapsed_time: 1000, rating: 0)
    assessments = Assessment.get(user_id: user_id, card_id: card_id)
    assert_equal(1, assessments.count)
  end

  test 'can add the same assessment multiple time' do
    Assessment.add(user_id: 1, card_id: 1, elapsed_time: 1000, rating: 1)
    Assessment.add(user_id: 1, card_id: 1, elapsed_time: 1000, rating: 1)
    Assessment.add(user_id: 1, card_id: 1, elapsed_time: 1000, rating: 1)
    assessments = Assessment.get(user_id: 1, card_id: 1)
    assert_equal(3, assessments.count)
  end
end
