
# User class
# The user class accesses a 'user deck', which is a
# ZSORTED redis set. The 'score' is the timestamp when
# the given card should be shown to the user again,
# and the value is simply the card id.
# This way the deck is always sorted correctly.

class User < ApplicationRecord
  after_create :initialize_deck

  # The persistence layer
  def data
    @data || @data = load_user_data
  end

  def repetition_algorithm
    @sm2 || @sm2 = SM2.new
  end

  def redis_namespace
    "sm2_#{Rails.env}/users/#{id}"
  end

  def load_user_data
    db = { 'development' => 0, 'test' => 1, 'production' => 2 }[Rails.env]
    redis = Redis::Namespace.new(redis_namespace, redis: Redis.new(db: db))
    UserData.new(redis)
  end

  def deck(page: 1, per_page: 0)
    data.deck(page: page, per_page: per_page)
  end

  # The user assess (rates) a card. Update the different
  # statistics and determine the next time the card should
  # show up to update the deck.
  def assess(card_id:, rating:, elapsed_time:)
    data.add_assessment(card_id: card_id, elapsed_time: elapsed_time, rating: rating)

    card_data = data.get_card_data(card_id)
    evaluation = repetition_algorithm.evaluate(rating: rating, card_data: card_data)
    data.update_card_data(card_id: card_id, card_data: evaluation[:card_data])

    # Remember the next time the card should be shown to the user
    data.update_card_interval(interval: evaluation[:interval], card_id: card_id)
  end

  # Given a new user, initialize it's cards deck
  # Set the timestamp to Time.now to show that all the
  # cards are already overdue.
  def initialize_deck
    # Delete the redis user data
    data.reset
    Card.all.each do |card|
      # zadd key, score, value
      data.update_card_interval(interval: 0.second, card_id: card.id)
    end
  end

  # Repetition session: cards to study today.
  def todays_session
    data.todays_session
  end

  # How many vocabulary words a user needs to review in the future.
  def forecast
    Statistics.forecast(deck: data.deck)
  end

  # How many times they've used each answer choice
  def answer_buttons
    Statistics.answer_buttons(assessments: data.assessments)
  end

  # Time spent on each card
  def cumulative_time
    Statistics.cumulative_time(assessments: data.assessments)
  end
end
