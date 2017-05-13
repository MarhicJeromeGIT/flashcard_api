# SuperMemo 2 algorithm implementation
# See https://www.supermemo.com/english/ol/sm2.htm
class SM2
  DEFAULT_E_FACTOR = 2.5
  FAILURE_THRESHOLD = 3

  DEFAULT_CARD_DATA = {
    'e_factor' => DEFAULT_E_FACTOR,
    'repetitions' => 0
  }.freeze

  # Evaluate a card with a given rating, and determine and update it's e_factor.
  # Return the interval of time in days when the card should show up again.
  def evaluate(card_data:, rating:)
    card_data = SM2::DEFAULT_CARD_DATA if card_data.empty?
    e_factor, repetitions = card_data.values_at('e_factor', 'repetitions')

    if rating >= 3
      e_factor = compute_new_e_factor(rating: rating, e_factor: e_factor)
      repetitions += 1
    else # start repetitions for the item from the beginning without changing the E-Factor
      repetitions = 1
    end

    # Determine and return the amount of time when the card should show up again
    # Cards with rating <= 3 keep beeing repeated!
    # "After each repetition session of a given day repeat again all items
    # that scored below four in the quality assessment. Continue the repetitions
    # until all of these items score at least four."
    repeat_interval = 0.second
    if rating > FAILURE_THRESHOLD
      repeat_interval = interval(repetitions: repetitions, e_factor: e_factor)
    end

    {
      card_data: {
        e_factor: e_factor,
        repetitions: repetitions
      },
      interval: repeat_interval
    }
  end

  # Compute the repetition interval (in days)
  # Return a Duration
  def interval(repetitions: 1, e_factor: SM2::DEFAULT_E_FACTOR)
    return 1.day if repetitions == 1
    return 6.days if repetitions == 2
    interval_seconds = interval(repetitions: repetitions - 1, e_factor: e_factor) * e_factor
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
