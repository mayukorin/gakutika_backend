class UserAndCompanyAndGakutika < ApplicationRecord
  belongs_to :user_and_company
  belongs_to :gakutika
  has_one :company, through: :user_and_company
  has_one :user, through: :user_and_company
  validates :user_and_company, uniqueness: { scope: :gakutika}
end
