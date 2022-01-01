class UserAndCompany < ApplicationRecord
  belongs_to :user
  belongs_to :company
  has_many :user_and_company_and_gakutikas
  # has_many :gakutikas, through: :user_and_company_and_gakutikas
end
