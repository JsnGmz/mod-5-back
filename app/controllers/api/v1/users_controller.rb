class Api::V1::UsersController < ApplicationController

  def create
    auth_params = Spotify.new.login(params[:spotifyUriCode])
    user_data = Spotify.new.grab_user_data(auth_params['access_token'])
    user = User.find_or_create_by(user_params(user_data))
    img_url = user_data['images'][0] ? user_data['images'][0]['url'] : nil
    encoded_access_token = encode_token(token: auth_params['access_token'])
    encoded_refresh_token = encode_token(token: auth_params['refresh_token'])
    user.update(profile_img_url: img_url, access_token: encoded_access_token, refresh_token: encoded_refresh_token)

    render json: user.to_json(except: %i[access_token refresh_token created_at updated_at])
  end

  private

  def user_params(user_info)
    params = { email: user_info['email'], display_name: user_info['display_name'], spotify_url: user_info['external_urls']['spotify'] }
  end

end