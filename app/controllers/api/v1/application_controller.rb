module Api::V1
  class ApplicationController < ActionController::API
    # authenticate the user from the token in the headers
    def authenticate_user
      @current_user = User.find_by_token(request.headers[:token])
      unless request.headers[:token].present? && @current_user
        render json: { error: 'Invalid header token' }, status: :unauthorized and return
      end
    end
  end
end
