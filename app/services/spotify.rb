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

  def request_new_token(refresh_token)
    body = body_params.dup
    body[:grant_type] = 'refresh_token'
    body[:refresh_token] = refresh_token
    # body = { grant_type: 'refresh_token', refresh_token: refresh_token }
    # header = { 'Authorization': "Basic #{Base64.strict_encode64(ENV['CLIENT_ID'])}:#{Base64.strict_encode64(ENV['CLIENT_SECRET'])}" }
    reset_response = RestClient.post('https://accounts.spotify.com/api/token', body)
    JSON.parse(reset_response)
  end

  def grab_user_data(access_token)
    user_response = RestClient.get(account_base_url, headers(access_token))
    JSON.parse(user_response.body)
  end

  def grab_users_top_artists(access_token)
    artist_info = RestClient.get("#{account_base_url}/top/artists", headers(access_token))
    JSON.parse(artist_info)
  end

  def grab_recommendation_genre(access_token, genre)
    recommendation_response = RestClient.get("#{api_base_url}/recommendations?seed_genres=#{genre}", headers(access_token))
    JSON.parse(recommendation_response)
  end

  def make_new_playlist(access_token, user_id)
    header = headers(access_token).dup
    header['Content-Type'] = 'application/json'
    body = { name: "New Playlist from Mod 5 #{Time.now}", public: true, description: 'Playlist generated by App.' }
    makeplayer_response = RestClient.post("#{api_base_url}/users/#{user_id}/playlists", JSON.generate(body), header)
    JSON.parse(makeplayer_response)
  end

  def add_track(access_token, playlist_id, uri)
    header = headers(access_token).dup
    header['Content-Type'] = 'application/json'
    body = { 'uris': [uri] }
    res = RestClient.post("#{api_base_url}/playlists/#{playlist_id}/tracks", JSON.generate(body), header)
    JSON.parse(res)
  end

  private

  def api_base_url
    'https://api.spotify.com/v1'
  end

  def account_base_url
    "#{api_base_url}/me"
  end

  def body_params
    body = {
      client_id: ENV['CLIENT_ID'],
      client_secret: ENV['CLIENT_SECRET']
    }
  end

  def headers(access_token)
    { 'Authorization': "Bearer #{access_token}" }
  end

end