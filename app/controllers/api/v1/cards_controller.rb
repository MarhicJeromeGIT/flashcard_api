module Api::V1
  # Use pagination, see http://jsonapi.org/examples/#pagination
  # GET /cards?page[number]=3&page=1&per_page=10
  class CardsController < ApplicationController
    before_action :authenticate_user, only: [:study_schedule, :todays_session]

    # GET /api/v1/cards
    # curl localhost:8080/api/v1/cards
    def index
      card_list = Rails.cache.fetch 'cards', expires_in: 1.hour do
        generate_card_list
      end
      render json: card_list
    end

    # GET /api/v1/study_schedule
    # curl localhost:8080/api/v1/study_schedule --header "token: 1234"
    # Return the cards, as an array of card ids, that the user has to study in order of priority (next one first)
    # Support paging with page and per_page parameters
    def study_schedule
      # The deck is already sorted in redis (zset) so we don't have much to do!
      deck_params = {}
      deck_params[:page] = params[:page].to_i if params[:page].present?
      deck_params[:per_page] = params[:per_page].to_i if params[:per_page].present?
      deck = @current_user.deck(deck_params)
      render json: {
        deck: deck
      }
    end

    # Return the cards we have to study today
    def todays_session
      render json: @current_user.todays_session
    end

    private

    # Called once and cached
    def generate_card_list
      list = {}
      cards = Card.all
      cards.each do |card|
        serialization = ActiveModelSerializers::SerializableResource.new(card)
        list[card.id] = serialization.as_json
      end
      list
    end
  end
end
