# The UserData class is the User class persistence layer
# It is responsible for storing the user data in redis
class UserData
  attr_accessor :redis

  def initialize(redis)
    @redis = redis
  end

  # Return all the assessments, as a hash
  def assessments
    assessments = {}
    @redis.keys.select { |key| key.starts_with? 'assessments' }.each do |key|
      card_id = key.split('/')[-1]
      assessments[card_id] = card_assessments(card_id)
    end
    assessments
  end

  def card_assessments(card_id)
    # hgetall returns an empty hash by default
    assessments = @redis.lrange "assessments/#{card_id}", 0, -1
    assessments.map { |assessment| JSON.parse assessment }
  end

  def add_assessment(card_id:, elapsed_time:, rating:)
    assessment = {
      elapsed_time: elapsed_time,
      rating: rating,
      time: Time.now.to_i # For eventual statistics
    }
    @redis.lpush "assessments/#{card_id}", assessment.to_json
  end

  def get_card_data(card_id)
    if @redis.hexists 'cards', card_id
      card_data = @redis.hget 'cards', card_id
      JSON.parse card_data
    else
      {}
    end
  end

  def update_card_data(card_id:, card_data:)
    @redis.hset 'cards', card_id, card_data.to_json
  end

  # Return the user deck, sorted by card's 'next time up'
  # Note that pagination start at page 1
  # By default return the full deck
  def deck(page: 1, per_page: 0)
    range_start = (page - 1) * per_page
    range_end = page * per_page - 1
    # zrange 0, -1 return the full set
    @redis.zrange 'deck', range_start, range_end, with_scores: true
  end

  def todays_session
    @redis.zrangebyscore 'deck', 0, Time.now.to_i, with_scores: false
  end

  def update_card_interval(interval:, card_id:)
    @redis.zadd 'deck', interval.from_now.to_i, card_id
  end

  def reset
    @redis.keys.each do |key|
      @redis.del key
    end
  end

  # For debug
  def to_hash
    data = {}
    data['deck'] = deck
    data['cards'] = @redis.hgetall 'cards'
    data['assessments'] = assessments
    data
  end
end
