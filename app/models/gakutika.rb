class Gakutika < ApplicationRecord
    belongs_to :user
    has_many :user_and_company_and_gakutikas, dependent: :destroy
    validates :title, presence: true, uniqueness: { scope: :user_id, case_sensitive: true }
    validates :content, presence: true
    validates :start_month, presence: true
    validates :end_month, presence: true
    validates :tough_rank, numericality: { only_integer: true, greater_than: 0 },
                            uniqueness: { scope: :user_id }
    has_many :user_and_companies, through: :user_and_company_and_gakutikas
    scope :eager_loading, -> { eager_load(user_and_companies: [:company, user_and_company_and_gakutikas: :gakutika]).order('user_and_companies.latest_interview_day DESC') }
end
