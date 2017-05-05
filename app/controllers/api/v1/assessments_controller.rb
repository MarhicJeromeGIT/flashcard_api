module Api::V1
  class AssessmentsController < ApplicationController
    before_action :authenticate_user, only: [:assess]

    # POST /assessments/{card_id}
    # curl -X POST localhost:8080/api/v1/assessments/1 --header "token: 1234"
    # User rated a card
    def assess
      # Check that card_id and rating are valid
      card_ids = Rails.cache.fetch 'card_ids' do
        Card.all.pluck(:id)
      end
      unless card_ids.include? params[:card_id].to_i
        render(json: { error: "Unknown card id #{params[:card_id]}" }, status: 422) and return
      end
      unless (0..5).to_a.include? params[:rating].to_i
        render(json: { error: "Invalid rating value #{params[:rating]}" }, status: 422) and return
      end

      # Update the user deck using a space repetition algorithm
      @current_user.assess(card_id: params[:card_id].to_i,
                           rating: params[:rating].to_i,
                           elapsed_time: params[:elapsed_time].to_i)
      render :success
    end
  end
end
