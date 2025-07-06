class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :payment
  enum status: { pending: 0, confirmed: 1, preparing: 2, dispatched: 3, delivered: 4, cancelled: 5 }
  accepts_nested_attributes_for :order_items
end
