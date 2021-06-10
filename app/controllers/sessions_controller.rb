class SessionsController < ApplicationController
  before_action :set_current_user_from_jwt, only: [:me, :sign_out]
  # post 'users/sign_up'
  def sign_up
    user = User.new(user_params)
    if user.save
      render json: {success: true}, status: :created
    else
      render json: {success: false, errors: user.errors.as_json},
           status: :bad_request
    end
  end

  # post 'users/sign_in'
  def sign_in
    user = User.find_by_email(params[:user][:email])
    if user.confirmed? && user.valid_password?(params[:user][:password])
      render json: {success: true, jwt: user.jwt(1.days.from_now)},
           status: :created
    else
      render json: {success: false}, status: :unauthorized
    end
  end

  # delete 'users/sign_out'
  def sign_out
    @current_user.generate_auth_token(true)
    @current_user.save
    render json: {success: true}
  end

  # get 'users/me'
  def me
    # set_current_user_from_jwt
    render json: { success: true, user: @current_user.as_json }
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name)
  end
end
