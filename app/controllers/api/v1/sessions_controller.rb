class Api::V1::SessionsController < ApplicationController
  def new
    query_params = {
        client_id: ENV['CLIENT_ID'],
        response_type: 'code',
        redirect_uri: ENV['REDIRECT_URI'],
        scope: 'user-read-email user-top-read playlist-modify-public playlist-modify-private',
        show_dialog: true
    }

    redirect_to "https://accounts.spotify.com/authorize?#{query_params.to_query}"
  end

  def create; end

end