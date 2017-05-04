require 'test_helper'

class StatisticsTest < ActiveSupport::TestCase
  def setup
    Rails.cache.clear
    FactoryGirl.create_list(:card, 30)
    @user = create(:user)
  end

  test 'the forecast statistics are correct' do
    deck = { cards:
      {
        1 => { next_time_up: 0 },
        2 => { next_time_up: 1.month.ago.to_i },
        3 => { next_time_up: Time.now.advance(days: 2).to_i },
        4 => { next_time_up: Time.now.advance(weeks: 3).to_i },
        5 => { next_time_up: Time.now.advance(months: 11, days: 15).to_i },
        6 => { next_time_up: Time.now.advance(months: 1, days: 10).to_i }
      } }
    forecast = Statistics.forecast(deck: deck)
    assert_equal(2, forecast[0])
    assert_equal(2, forecast[1])
    assert_equal(1, forecast[12])
    assert_equal(1, forecast[2])
  end

  test 'the answer buttons statistics are correct' do
    # Add assessments to random cards
    expected_answer_buttons = Hash.new(0)
    100.times do
      rating = rand(5)
      expected_answer_buttons[rating] += 1
      Assessment.add(user_id: @user.id,
                     card_id: Card.offset(rand(Card.count)).first.id,
                     elapsed_time: 0,
                     rating: rating)
    end
    answer_buttons = Statistics.answer_buttons(user_id: @user.id)
    assert_equal(answer_buttons, expected_answer_buttons)
  end

  test 'the cumulative time statistics are correct' do
    # Add assessments to random cards
    expected_cumulative_times = Hash.new(0)

    100.times do
      elapsed_time = rand(10000)
      card_id = Card.offset(rand(Card.count)).first.id
      expected_cumulative_times[card_id] += elapsed_time
      Assessment.add(user_id: @user.id,
                     card_id: card_id,
                     elapsed_time: elapsed_time,
                     rating: 0)
    end
    cumulative_time = Statistics.cumulative_time(user_id: @user.id)
    assert_equal(cumulative_time.slice(*expected_cumulative_times.keys), expected_cumulative_times)
  end
end
