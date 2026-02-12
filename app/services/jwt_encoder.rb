class JwtEncoder
  SECRET_KEY = Rails.application.secret_key_base

  def self.call(payload, exp: 15.minutes.from_now, type: 'access')
    payload[:exp] = exp.to_i
    payload[:type] = type
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end
end
