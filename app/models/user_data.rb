# The UserData class is the User class persistence layer
# It is responsible for storing the user data in redis
class UserData < Ohm::Model
  # Only the assessment data is stored using Ohm
  # The deck is stored directly using redis because I
  # 'need/like' the sorted set functionality (though I could use
  # Ohm Set an sort_by(:timestamp) for example.
  # TODO: ohmify sm2 card data storage too.
  set :assessments, :Assessment
  set :decks, :Deck
  reference :user, :User

  def initialize(attributes)
    super(attributes)
    db = { 'development' => 0, 'test' => 1, 'production' => 2 }[Rails.env]
    @redis = Redis::Namespace.new("sm2_#{Rails.env}/users/#{user.id}", redis: Redis.new(db: db))
  end

  def card_assessments(card_id)
    assessments.find(card_id: card_id).to_a
  end

  def add_assessment(card_id:, elapsed_time:, rating:)
    # Persistence with Ohm
    assessment = Assessment.create(
      rating: rating,
      elapsed_time: elapsed_time,
      time: Time.now.to_i,
      card_id: card_id
    )
    assessments.add(assessment)
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

  # Create and return a new empty deck
  def create_deck
    deck = Deck.create(user: user)
    decks.add(deck)
    deck
  end

  def reset
    @redis.keys.each do |key|
      @redis.del key
    end
    assessments.each do |assessment|
      # beurk
      assessments.delete(assessment)
    end
    decks.each do |deck|
      # beurk
      decks.delete(deck)
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
