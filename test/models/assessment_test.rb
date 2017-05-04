require 'test_helper'

class AssessmentTest < ActiveSupport::TestCase
  def setup
    Rails.cache.clear
  end

  test 'can add and fetch assessments from redis' do
    user_id = 1
    card_id = 1
    assert_equal([], Assessment.get(user_id: user_id, card_id: card_id))
    elapsed_time = 1000
    rating = 0
    assert_equal('OK', Assessment.add(user_id: user_id, card_id: card_id, elapsed_time: elapsed_time, rating: rating))
    assert_equal('OK', Assessment.add(user_id: user_id, card_id: card_id, elapsed_time: 1500, rating: 1))
    assessments = Assessment.get(user_id: user_id, card_id: card_id)
    assert_equal(2, assessments.count)
    assert_equal({ elapsed_time: elapsed_time, rating: rating }, assessments.first.slice(:elapsed_time, :rating))
  end
end
