class Gakutika < ApplicationRecord
    belongs_to :user
    has_many :questions, dependent: :destroy
    has_many :user_and_company_and_gakutikas, dependent: :destroy
    validates :title, presence: true
    validates :content, presence: true
    validates :start_month, presence: true
    validates :end_month, presence: true
    validates :tough_rank, numericality: { only_integer: true, greater_than: 0 },
                            uniqueness: { scope: :user_id }
    # has_many :companies, through: :user_and_company_and_gakutikas
    has_many :user_and_companies, through: :user_and_company_and_gakutikas
end
