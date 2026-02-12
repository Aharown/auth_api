class UsersController < ApplicationController
  before_action :authorize_request, only: [:me]

  def create
    user = User.new(user_params)

    if user.save
      access_token = JwtEncoder.call({ user_id: user.id }, exp: 15.minutes.from_now, type: 'access')
      refresh_token = JwtEncoder.call({ user_id: user.id }, exp: 7.days.from_now, type: 'refresh')
      render json: {
        user: {
        id: user.id,
        email: user.email
      },
      access_token: access_token,
      refresh_token: refresh_token,
      message: "User created successfully" },
      status: :created
    else
      render json: { errors: user.errors.full_messages },
    status: :unprocessable_entity
    end
  end

  def me
    render json: { id: current_user.id, email: current_user.email }, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end
