class UserAndCompanyAndGakutika < ApplicationRecord
  belongs_to :user_and_company
  belongs_to :gakutika
  has_one :company, through: :user_and_company
end
