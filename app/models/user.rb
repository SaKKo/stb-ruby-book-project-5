class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable 

  before_validation :generate_auth_token, on: [:create]

  def generate_auth_token(force = false) # ถ้าไม่ส่งอะไรมา ให้ force เป็น false
    # เครื่องหมาย ||= เทียบเท่ากับเช็คว่า auth_token เป็น nil หรือไม่
    # ถ้าไม่ใช่ nil ให้ข้ามบรรทัดนี้ไป
    self.auth_token ||= SecureRandom.urlsafe_base64

    # บังคับเปลี่ยน token ถ้า force เป็น true
    self.auth_token = SecureRandom.urlsafe_base64 if force
  end

  def jwt(exp = 1.days.from_now)
    payload = { exp: exp.to_i, auth_token: self.auth_token }
    JWT.encode payload, Rails.application.credentials.secret_key_base, 'HS256'
  end
end

