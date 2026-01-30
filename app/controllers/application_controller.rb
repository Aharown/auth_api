class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    render json: { error: e.message }, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: "Record not found" }, status: :not_found
  end
end
