# Collection of helper functions for statistics generation
class Statistics < ApplicationRecord
  # How many vocabulary words a user needs to review in the future.
  def self.forecast(deck:)
    # TODO: let the user select scale, ie month-by-month, week-by-week etc?
    current_time = Time.now.to_i
    results = Hash.new(0)
    deck[:cards].each do |_key, card_data|
      diff_months = (card_data[:next_time_up] - current_time).to_f / 1.month.to_f
      # Classify:
      # - 0 : the late cards (they should have been studied already).
      # - 1 : forecast to appear within the next month
      # and so on.
      diff_months = [0, diff_months.ceil].max
      results[diff_months] += 1
    end
    results
  end

  def self.answer_buttons(user_id:)
    buttons = Hash.new(0)
    Card.all.each do |card|
      assessments = Assessment.get(user_id: user_id, card_id: card.id)
      assessments.each do |assessment|
        rating = assessment[:rating]
        buttons[rating] += 1
      end
    end
    buttons
  end

  def self.cumulative_time(user_id:)
    times = Hash.new(0)
    Card.all.each do |card|
      times[card.id] = 0
      assessments = Assessment.get(user_id: user_id, card_id: card.id)
      assessments.each do |assessment|
        elapsed_time = assessment[:elapsed_time]
        times[card.id] += elapsed_time
      end
    end
    times
  end
end
