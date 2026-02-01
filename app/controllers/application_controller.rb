class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    render json: { error: e.message }, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Record not found" }, status: :not_found
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless decoded

    @current_user = User.find(decoded[:user_id]) if decoded

    return render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  attr_reader :current_user
end
