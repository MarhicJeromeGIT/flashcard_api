module Api::V1
  class AssessmentsController < ApplicationController
    before_action :authenticate_user, only: [:assess]
    before_action :check_assessment_params, only: [:assess]

    # POST /assessments/{card_id}
    # curl -X POST localhost:8080/api/v1/assessments/1 --header "token: 1234"
    # User rated a card
    def assess
      # Update the user deck using a space repetition algorithm
      @current_user.assess(card_id: params[:card_id].to_i,
                           rating: params[:rating].to_i,
                           elapsed_time: params[:elapsed_time].to_i)
      render :success
    end

    private

    def check_assessment_params
      card_ids = Rails.cache.fetch 'card_ids', expires_in: 1.hour do
        Card.all.pluck(:id)
      end
      unless card_ids.include?(params[:card_id].to_i)
        render(json: { error: "Unknown card_id #{params[:card_id]}" }, status: 422) and return
      end

      unless params.key?(:rating) && (0..5).to_a.include?(params[:rating].to_i)
        render(json: { error: "Invalid or Missing rating value #{params[:rating]}" }, status: 422) and return
      end

      unless params.key?(:elapsed_time)
        render(json: { error: 'Missing elapsed_time value' }, status: 422) and return
      end
    end
  end
end
