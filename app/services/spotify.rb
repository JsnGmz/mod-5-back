class Spotify < ApplicationService
  def new; end

  def login(spotify_code)
    body = body_params.dup
    body[:grant_type] = 'authorization_code'
    body[:code] = spotify_code
    body[:redirect_uri] = ENV['REDIRECT_URI']
    login_response = RestClient.post('https://accounts.spotify.com/api/token', body)
    JSON.parse(login_response.body)
  end

  def grab_user_data(access_token)
    user_response = RestClient.get('https://api.spotify.com/v1/me', { 'Authorization': "Bearer #{access_token}"})
    JSON.parse(user_response.body)
  end

  private

  def body_params
    body = {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET']
    }
  end

end