class ApplicationController < ActionController::API
  def set_current_user_from_jwt
    auth_header = request.headers["Authorization"]
    raise STBAuthenticationError.new("No token") if auth_header.blank?
    bearer = auth_header.split.first
    raise STBAuthenticationError.new("Bad format") if bearer != "Bearer"
    jwt = auth_header.split.last
    raise STBAuthenticationError.new("Bad format") if jwt.blank?
    key = Rails.application.credentials.secret_key_base
    decoded = JWT.decode(jwt, key, 'HS256')
    payload = decoded.first
    if payload.blank? || payload["auth_token"].blank?
      raise STBAuthenticationError.new("Bad token")
    end
    @current_user = User.find_by_auth_token(payload["auth_token"])
    raise STBAuthenticationError.new("Bad token") if @current_user.blank?
  end
end

