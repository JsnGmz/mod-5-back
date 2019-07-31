class Api::V1::SpotifyController < ApplicationController
  before_action :find_current_user
  before_action :request_new_token, only: %i[grab_users_top_artists generate_recommendations]

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
    decode_token(@user['access_token'])[0]
  end

  def request_new_token
    response = Spotify.new.request_new_token(decode_token(@user['refresh_token'])[0]['token'])
    @user.update(refresh_token: encode_token(response['refresh_token'])) if response['refresh_token']
    @user.update(access_token: encode_token(response['access_token']))
  end

end
