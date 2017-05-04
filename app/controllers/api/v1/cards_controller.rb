module Api::V1
  # Use pagination, see http://jsonapi.org/examples/#pagination
  # GET /cards?page[number]=3&page=1&per_page=10
  class CardsController < ApplicationController
    before_action :authenticate_user, only: [:vocabulary]

    # TODO: Maybe add pagination here?
    # GET /api/v1/cards
    # curl localhost:8080/api/v1/cards
    def index
      card_list = Rails.cache.fetch 'cards' do
        generate_card_list
      end
      render json: card_list
    end

    # GET /api/v1/vocabulary
    # curl localhost:8080/api/v1/vocabulary --header "token: 1234"
    # Return the cards, as an array of card ids, that the user has to study in order of priority (next one first)
    # Support paging with page and per_page parameters
    # TODO: to much computation in that method, optimize
    def vocabulary

      # Sort the full deck by 'next_time_up' increasing order
      voc = @current_user.deck[:cards].sort do |a, b|
        a[1][:next_time_up] <=> b[1][:next_time_up]
      end
      
      # Separate the card ids from the next_time_up value,
      # in two different arrays.
      card_ids = []
      card_times = []
      voc.each do |id,time_hash|
        card_ids << id
        card_times << time_hash[:next_time_up]
      end
      
      render json: {
        card_ids: paginate_array(card_ids),
        card_times: paginate_array(card_times),
        server_time: Time.now.to_i
      }
    end

    private

    def paginate_array(array)
      page = params[:page].to_i || 1
      per_page = params[:per_page].to_i || 0
      array[(page - 1) * per_page..(page * per_page - 1)]
    end

    # Called once and cached
    def generate_card_list
      cards = Card.all
      cards.map do |card|
        serialization = ActiveModelSerializers::SerializableResource.new(card)
        { card.id => serialization.as_json }
      end
    end
  end
end
