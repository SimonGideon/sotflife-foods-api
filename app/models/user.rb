class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  enum role: { admin: 0, client: 1, rider: 2, superadmin: 3 }
  validates :name, presence: true
  validates :phone, presence: true
  has_one :rider_profile
end
