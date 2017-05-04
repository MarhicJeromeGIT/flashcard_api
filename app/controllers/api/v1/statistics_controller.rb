module Api::V1
  class StatisticsController < ApplicationController
    before_action :authenticate_user

    # GET /api/v1/statistics/forecast
    # curl localhost:8080/api/v1/statistics/forecast --header "token: 1234"
    # How many vocabulary words a user needs to review in the future.
    def forecast
      render json: @current_user.forecast
    end

    # GET /api/v1/statistics/answer_buttons
    # curl localhost:8080/api/v1/statistics/answer_buttons --header "token: abcd"
    # How many times they've used each answer choice.
    def answer_buttons
      render json: @current_user.answer_buttons
    end

    # GET /api/v1/statistics/cumulative_time
    # curl localhost:8080/api/v1/statistics/cumulative_time --header "token: abcd"
    # The total time spent on each card, in ms
    def cumulative_time
      render json: @current_user.cumulative_time
    end
  end
end
