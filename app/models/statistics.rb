# Collection of helper functions for statistics generation
class Statistics < ApplicationRecord
  def self.forecast(deck:, interval: 1.month)
    results = Hash.new(0)
    current_time = Time.now.to_i
    deck.map do |_card_id, timestamp|
      classify = (timestamp - current_time) / interval.to_f
      classify = [0, classify.ceil].max
      results[classify] += 1
    end
    results
  end

  def self.forecast_weeks(deck:)
    forecast(deck: deck, interval: 1.week)
  end

  def self.answer_buttons(assessments:)
    buttons = Hash.new(0)
    assessments.each do |assessment|
      rating = assessment.rating.to_i
      buttons[rating] += 1
    end
    buttons
  end

  def self.cumulative_time(assessments:)
    times = Hash.new(0)
    assessments.each do |assessment|
      elapsed_time = assessment.elapsed_time.to_i
      card_id = assessment.card_id.to_i
      times[card_id] += elapsed_time
    end
    times
  end
end
