class Payment < ApplicationRecord
  belongs_to :order
  enum payment_method: { mpesa: 0, cash: 1, card: 2 }
  enum status: { paid: 0, pending: 1, failed: 2 }
end
