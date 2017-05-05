# Represent a user self-evaluation (assessment) for a given card.
# There is no underlying Active record, we fetch directly from cache (Redis)
# The Redis key is of the form:
# /users/{user_id}/cards/{card_id} and return an array of assessments of the form:
# {
#   elapsed_time: (in ms, time spent before answering)
#   rating: (in [0..5], user self evaluation score)
#   time: in sec, the server time when the card was assessed (ensure the hash is unique, and may be useful for statistics later)
# }
class Assessment
  def self.add(user_id:, card_id:, elapsed_time:, rating:)
    # TODO: Add validation of inputs + SLACK hook for error handlers
    new_assessment = {
      elapsed_time: elapsed_time,
      rating: rating,
      time: Time.now.to_i
    }
    $redis.lpush format_key(user_id: user_id, card_id: card_id),
                 new_assessment.to_json
  end

  # Return an array of the user assessments hashes for the given card.
  def self.get(user_id:, card_id:)
    response = $redis.lrange format_key(user_id: user_id, card_id: card_id), 0, -1
    response.map { |str| JSON.parse str }
  end

  private

  def self.format_key(user_id:, card_id:)
    "users/#{user_id}/cards/#{card_id}"
  end
end
