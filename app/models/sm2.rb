# SuperMemo 2 algorithm implementation
# See https://www.supermemo.com/english/ol/sm2.htm
class SM2
  DEFAULT_E_FACTOR = 2.5

  # SM2 'object'
  # {
  #    repetition: number of repetitions
  #    e_factor: see algo
  #    interval: when the card will show up again, in days
  # }
  def new_sm2_hash
    {
      repetition: 0,
      e_factor: SM2::DEFAULT_E_FACTOR,
      interval: 0
    }
  end

  # Evaluate and return an sm2 object depending on the rating given by the user
  def evaluate(sm2:, rating:)
    new_sm2 = sm2
    new_sm2[:repetition] += 1
    if rating >= 3
      new_e_factor = compute_new_e_factor(rating: rating, e_factor: sm2[:e_factor] || SM2::DEFAULT_E_FACTOR)
      new_sm2[:e_factor] = new_e_factor
    else # start repetitions for the item from the beginning without changing the E-Factor
      new_sm2[:repetition] = 1
    end
    new_sm2[:interval] = interval(repetition: new_sm2[:repetition] || 1, e_factor: new_sm2[:e_factor])
    sm2
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
