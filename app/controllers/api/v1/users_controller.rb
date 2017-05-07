module Api::V1
  class UsersController < ApplicationController
    before_action :authenticate_user, only: [:reset_deck]

    # POST /api/v1/user/reset_deck
    # curl -X POST "localhost:8080/api/v1/user/reset_deck" -H  "accept: application/json" -H  "token: abcd"
    # Reset the user's study deck
    def reset_deck
      @current_user.initialize_deck
      render :success
    end
  end
end
