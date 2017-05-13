class Deck < Ohm::Model
  reference :user, :User

  def initialize(attributes)
    super(attributes)
    db = { 'development' => 0, 'test' => 1, 'production' => 2 }[Rails.env]
    @redis = Redis::Namespace.new("sm2_#{Rails.env}/users/#{user.id}", redis: Redis.new(db: db))
  end

  # Return the user deck, sorted by card's 'next time up'
  # Note that pagination start at page 1
  # By default return the full deck
  def deck(page: 1, per_page: 0)
    range_start = (page - 1) * per_page
    range_end = page * per_page - 1
    # zrange 0, -1 return the full set
    @redis.zrange "deck/#{id}", range_start, range_end, with_scores: true
  end

  def todays_session
    @redis.zrangebyscore "deck/#{id}", 0, Time.now.to_i, with_scores: false
  end

  def update_card_interval(interval:, card_id:)
    @redis.zadd "deck/#{id}", interval.from_now.to_i, card_id
  end
end
