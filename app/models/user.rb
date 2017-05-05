# User class
# The user class accesses a 'user deck', which is a
# ZSORTED redis set. The 'score' is the timestamp when
# the given card should be shown to the user again,
# and the value is simply the card id.
# This way the deck is always sorted correctly.
class User < ApplicationRecord
  after_create :initialize_deck

  @@sm2 = nil
  def self.repetition_algorithm
    @@sm2 || @@sm2 = SM2.new
  end

  def format_key
    "users/#{id}/deck"
  end

  # Update the user deck when a card is assessed
  # Write the next time the card should be shown to the user
  # Interval is a ActiveSupport::Duration.
  def update_deck(card_id:, interval:)
    # TODO: error check if interval is not a Duration !
    # TODO: error check if card_id is not valid !
    $redis.zadd format_key, interval.from_now.to_i, card_id
  end

  # The user assess (rates) a card. Update the different
  # statistics and determine the next time the card should
  # show up to update the deck.
  def assess(card_id:, rating:, elapsed_time:)
    Assessment.add(user_id: id, card_id: card_id, elapsed_time: elapsed_time, rating: rating)
    # TODO: gonna need a 'strategy design pattern' here, maybe a 'SpaceRepetitionAlgorithm' class
    interval = User.repetition_algorithm.evaluate(user_id: id, card_id: card_id, rating: rating)
    update_deck(card_id: card_id, interval: interval)
  end

  # Return the user deck, sorted by card's 'next time up'
  # Note that pagination start at page 1
  # By default return the full deck
  def deck(page: 1, per_page: 0)
    range_start = (page - 1) * per_page
    range_end = page * per_page - 1
    # zrange 0, -1 return the full set
    $redis.zrange format_key, range_start, range_end, with_scores: true
  end

  # Given a new user, initialize it's cards deck
  # Set the timestamp to Time.now to show that all the
  # cards are already overdue.
  def initialize_deck
    $redis.del format_key
    timestamp = Time.now.to_i
    Card.all.each do |card|
      # zadd key, score, value
      $redis.zadd format_key, timestamp, card.id
    end
  end

  # How many vocabulary words a user needs to review in the future.
  def forecast
    Statistics.forecast(deck: deck)
  end

  # How many times they've used each answer choice
  def answer_buttons
    Statistics.answer_buttons(user_id: id)
  end

  # Time spent on each card
  def cumulative_time
    Statistics.cumulative_time(user_id: id)
  end
end
