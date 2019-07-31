class Api::V1::AuthController < ApplicationController
  def auto_login
    user = User.find_by(id: request.headers['Authorization'])
    if user
      render json: user
    else
      render json: { errors: 'No user found' }
    end
  end
end