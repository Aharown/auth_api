class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JwtEncoder.call(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
