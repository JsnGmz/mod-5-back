class ApplicationController < ActionController::API

  def encode_token(payload)
    JWT.encode(payload, ENV['HMAC_SECRET'], ENV['HMAC_ALGO'])
  end

  def decode_token(token)
    JWT.decode(token, ENV['HMAC_SECRET'], true, algorithm: ENV['HMAC_ALGO'])
  end

end
