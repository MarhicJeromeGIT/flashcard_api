# User class
class User < ApplicationRecord
  after_create :initialize_deck

  def format_request
    "users/#{id}/deck"
  end

  # Update the user deck when a card is assessed
  # Write the next time the card should be shown to the user
  # Interval is a ActiveSupport::Duration.
  def update_deck(card_id:, interval:)
    # TODO: error check if interval is not a Duration !
    # TODO: error check if card_id is not valid !
    deck = Rails.cache.fetch format_request
    deck[:cards][card_id][:next_time_up] = interval.from_now.to_i
    Rails.cache.write format_request, deck
  end

  # The user assess (rates) a card. Update the different
  # statistics and determine the next time the card should
  # show up to update the deck.
  def assess(card_id:, rating:, elapsed_time:)
    # TODO: add timing
    Assessment.add(user_id: id, card_id: card_id, elapsed_time: elapsed_time, rating: rating)
    sm2 = SM2.new
    # TODO: gonna need a 'strategy design pattern' here, maybe an 'SpaceRepetitionAlgorithm' class
    card_eval = Rails.cache.fetch "users/#{id}/sm2/#{card_id}" do
      sm2.new_sm2_hash
    end
    card_eval = sm2.evaluate(sm2: card_eval, rating: rating)
    # Save the results:
    Rails.cache.write "users/#{id}/sm2/#{card_id}", card_eval
    # Update the deck with the information as to when the card should show up next
    interval = card_eval[:interval]
    update_deck(card_id: card_id, interval: interval)
  end

  # Return the user deck
  # Note that pagination start at page 1
  # By default return the full deck
  def deck(page: 1, per_page: 0)
    deck = Rails.cache.fetch format_request
    # paginate with the Hash#Slice function : only return the key/values pairs whose key
    # is in the keys array.
    keys = deck[:cards].keys[(page - 1) * per_page..(page * per_page - 1)]
    deck[:cards] = deck[:cards].slice(*keys)
    deck
  end

  # Given a new user, initialize it's cards deck to schedule them for showing immediately
  def initialize_deck
    cards = {}
    Card.all.each do |card|
      cards[card.id] = {
        next_time_up: 0
      }
    end
    deck = {
      cards: cards
    }
    Rails.cache.write format_request, deck
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
