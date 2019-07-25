class Api::V1::SpotifyController < ApplicationController
  before_action :find_current_user

  def grab_users_top_artists
    top_artists = Spotify.new.grab_users_top_artists(decoded_user_token)
    render json: top_artists
  end

  def generate_recommendations
    recommendation = Spotify.new.grab_recommendation_genre(decoded_user_token, params[:genre])
    render json: recommendation
  end

  private

  def find_current_user
    @user = User.find(params[:id])
  end

  def decoded_user_token
    decode_token(@user['access_token'])[0]['token']
  end

end
