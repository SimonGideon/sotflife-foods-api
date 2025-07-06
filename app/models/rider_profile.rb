class RiderProfile < ApplicationRecord
  belongs_to :user
  enum transport_mode: { foot: 0, bicycle: 1, motorbike: 2 }
  validates :user_id, uniqueness: true
end
