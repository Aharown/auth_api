class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token = JwtEncoder.call({ user_id: user.id }, exp: 15.minutes.from_now, type: 'access')
      refresh_token = JwtEncoder.call({ user_id: user.id }, exp: 7.days.from_now, type: 'refresh')
      render json: { access_token: access_token, refresh_token: refresh_token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def refresh
    header = request.headers['Authorization']
    return render json: { error: 'Missing token' }, status: :unauthorized unless header

    token = header.split(' ').last
    decoded = JwtDecoder.call(token)

    case decoded
    when :expired
      return render json: { error: 'Refresh token has expired' }, status: :unauthorized
    when nil
      return render json: { error: 'Invalid token' }, status: :unauthorized
    end

    unless decoded[:type] == 'refresh'
      return render json: { error: 'Invalid token type' }, status: :unauthorized
    end

    user = User.find_by(id: decoded[:user_id])
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless user

    new_access_token = JwtEncoder.call(
      { user_id: user.id },
      exp: 15.minutes.from_now,
      type: 'access'
    )

    render json: { access_token: new_access_token }
  end
end
