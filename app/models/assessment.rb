# Represent a user self-evaluation (assessment) for a given card.
# There is no underlying Active record, we fetch directly from cache (Redis)
# The Redis key is of the form:
# /users/{user_id}/cards/{card_id} and return an array of assessments of the form:
# {
#   elapsed_time: (in ms, time spent before answering)
#   rating: (in [0..5], user self evaluation score)
#   time: in sec, the server time when the card was assessed
# }
class Assessment
  def self.format_request(user_id:, card_id:)
    "users/#{user_id}/cards/#{card_id}"
  end

  def self.add(user_id:, card_id:, elapsed_time:, rating:)
    # TODO: Add validation of inputs + SLACK hook for error handlers
    previous_assessments = Rails.cache.fetch format_request(user_id: user_id, card_id: card_id) do
      []
    end
    previous_assessments << {
      elapsed_time: elapsed_time,
      rating: rating,
      time: Time.now.to_i
    }
    Rails.cache.write format_request(user_id: user_id, card_id: card_id), previous_assessments
  end

  # Return an array of the user assessments for the given card.
  def self.get(user_id:, card_id:)
    Rails.cache.fetch format_request(user_id: user_id, card_id: card_id) do
      []
    end
  end
end
