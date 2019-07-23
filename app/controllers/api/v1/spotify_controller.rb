class Api::V1::SpotifyController < ApplicationController
  before_action :find_current_user

  def grab_users_top_artists
    top_artists = Spotify.new.grab_users_top_artists(decode_token(@user['access_token'])[0]['token'])
    render json: top_artists
  end

  private

  def find_current_user
    @user = User.find(params[:id])
  end

end
