# SuperMemo 2 algorithm implementation
# See https://www.supermemo.com/english/ol/sm2.htm
class SM2
  DEFAULT_E_FACTOR = 2.5

  def format_key(user_id:, card_id:)
    "users/#{user_id}/sm2/#{card_id}"
  end

  # Evaluate a card with a given rating, and determine and update it's e_factor.
  # Return the interval of time in days when the card should show up again.
  def evaluate(user_id:, card_id:, rating:)
    key = format_key(user_id: user_id, card_id: card_id)
    repetition = if $redis.hexists key, 'repetition'
                   # funny that there is no integer type in redis ?
                   repetition = $redis.hget key, 'repetition'
                   repetition.to_i
                 else
                   0
                 end
    e_factor = if $redis.hexists key, 'e_factor'
                 e_factor = $redis.hget key, 'e_factor'
                 e_factor.to_f
               else
                 SM2::DEFAULT_E_FACTOR
               end

    if rating >= 3
      e_factor = compute_new_e_factor(rating: rating, e_factor: e_factor)
      repetition += 1
    else # start repetitions for the item from the beginning without changing the E-Factor
      repetition = 1
    end

    # Update redis data:
    $redis.hmset format_key(user_id: user_id, card_id: card_id),
                 'repetition', repetition,
                 'e_factor', e_factor

    # Determine and return the amount of time when the card should show up again
    interval(repetition: repetition, e_factor: e_factor)
  end

  # Compute the repetition interval (in days)
  # Return a Duration
  def interval(repetition: 1, e_factor: SM2::DEFAULT_E_FACTOR)
    return 1.day if repetition == 1
    return 6.days if repetition == 2
    interval_seconds = interval(repetition: repetition - 1, e_factor: e_factor) * e_factor
    (interval_seconds / 1.day).round.days
  end

  # Compute new E factor
  # EF':=EF+(0.1-(5-q)*(0.08+(5-q)*0.02))
  def compute_new_e_factor(rating:, e_factor:)
    new_e_factor = e_factor +
                   (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02))
    [1.3, new_e_factor].max
  end
end
