require 'test_helper'

class SM2Test < ActiveSupport::TestCase
  def setup
    @algo = SM2.new
  end

  test 'that for q=4 the E-Factor does not change.' do
    sm2 = @algo.new_sm2_hash
    original_e_factor = sm2[:e_factor]
    repetitions = 4
    repetitions.times do
      sm2 = @algo.evaluate(sm2: sm2, rating: 4)
    end
    assert_equal(sm2[:repetition], repetitions)
    assert_equal(sm2[:e_factor], original_e_factor)
  end

  test 'interval ending conditions' do
    sm2 = @algo.new_sm2_hash
    sm2 = @algo.evaluate(sm2: sm2, rating: 5)
    assert_equal(1.day, sm2[:interval])
    sm2 = @algo.evaluate(sm2: sm2, rating: 5)
    assert_equal(6.days, sm2[:interval])
  end
end
