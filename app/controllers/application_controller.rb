class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    render json: { error: e.message }, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Record not found" }, status: :not_found
  end

  def authorize_request
    header = request.headers['Authorization']
    return render json: { error: 'Missing token' }, status: :unauthorized unless header

    token = header.split(' ').last if header
    decoded = JwtDecoder.call(token)

    case decoded
    when :expired
      return render json: { error: 'Token has expired' }, status: :unauthorized
    when nil
      return render json: { error: 'Invalid token' }, status: :unauthorized
    end

    @current_user = User.find(decoded[:user_id]) if decoded
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  attr_reader :current_user 
end
