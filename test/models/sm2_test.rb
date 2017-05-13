require 'test_helper'

class SM2Test < ActiveSupport::TestCase
  test 'that for q=4 the E-Factor does not change.' do
    original_e_factor = 2
    e_factor = SM2.new.compute_new_e_factor(rating: 4, e_factor: original_e_factor)
    assert_equal(original_e_factor, e_factor)

    original_e_factor = 2.5
    e_factor = SM2.new.compute_new_e_factor(rating: 4, e_factor: original_e_factor)
    assert_equal(original_e_factor, e_factor)

    original_e_factor = 4
    e_factor = SM2.new.compute_new_e_factor(rating: 4, e_factor: original_e_factor)
    assert_equal(original_e_factor, e_factor)

    original_e_factor = 5
    e_factor = SM2.new.compute_new_e_factor(rating: 4, e_factor: original_e_factor)
    assert_equal(original_e_factor, e_factor)
  end

  test 'interval ending conditions' do
    interval = SM2.new.interval(repetitions: 1, e_factor: 5)
    assert_equal(1.day, interval)
    interval = SM2.new.interval(repetitions: 2, e_factor: 4)
    assert_equal(6.days, interval)
  end
end
