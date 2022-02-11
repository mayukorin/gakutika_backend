class UserAndCompany < ApplicationRecord
  belongs_to :user
  belongs_to :company, optional: true
  has_many :user_and_company_and_gakutikas, dependent: :destroy
  # has_many :gakutikas, through: :user_and_company_and_gakutikas
  # validates :user_id, uniqueness: { scope: :company_id }
end
