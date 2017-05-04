module Api::V1
  class AssessmentsController < ApplicationController
    before_action :authenticate_user, only: [:assess]

    # POST /assessments/{card_id}
    # curl -X POST localhost:8080/api/v1/assessments/1 --header "token: 1234"
    # User rated a card
    def assess
      # TODO: error check for rating in[0..5]
      # TODO: put the list of id's in the cache too
      card_ids = Card.all.pluck(:id)
      unless card_ids.include? params[:card_id].to_i
        render(json: { error: "Unknown card id #{params[:card_id]}" }, status: 422) and return
      end

      # Update the user deck using a space repetition algorithm
      @current_user.assess(card_id: params[:card_id].to_i,
                           rating: params[:rating].to_i,
                           elapsed_time: params[:elapsed_time].to_i)
      render :success
    end
  end
end
