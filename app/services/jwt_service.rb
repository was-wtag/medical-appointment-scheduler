# frozen_string_literal: true

class JwtService
  SECRET = Rails.application.secrets.secret_key_base
  ALGORITHM = 'HS256'
  JWT_EXPIRES_IN = 24.hours.from_now

  def self.encode(payload, exp = JWT_EXPIRES_IN)
    payload['exp'] = exp.to_i
    JWT.encode(payload, SECRET, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, SECRET, true, algorithm: ALGORITHM).first
  end
end
