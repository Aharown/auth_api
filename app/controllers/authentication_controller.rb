class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token = JwtEncoder.call({ user_id: user.id }, exp: 15.minutes.from_now, type: 'access')
      refresh_token = RefreshTokenService.create_for(user)

      render json: { access_token: access_token, refresh_token: refresh_token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def refresh
    header = request.headers['Authorization']
    return render json: { error: 'Missing token' }, status: :unauthorized unless header

    token = header.split(' ').last
    refresh_record = RefreshTokenService.find(token)
    return render json: { error: 'Invalid token' }, status: :unauthorized unless refresh_record

    user = refresh_record.user
    refresh_record.revoke!
    new_refresh_token = RefreshTokenService.create_for(user)
    new_access_token = JwtEncoder.call({ user_id: user.id }, exp: 15.minutes.from_now, type: 'access')

    render json: { access_token: new_access_token, refresh_token: new_refresh_token  }
  end

  def logout
    header = request.headers['Authorization']
    return render json: { error: 'Missing token' }, status: :unauthorized unless header

    token = header.split(' ').last
    refresh_record = RefreshTokenService.find(token)
    return render json: { error: 'Invalid or already revoked token' }, status: :unauthorized unless refresh_record

    refresh_record.revoke!

    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
