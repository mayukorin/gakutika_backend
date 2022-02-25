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
    scope :eager_loading, -> { eager_load(user_and_company_and_gakutikas: [user_and_company: :user], user_and_companies: [:company, user_and_company_and_gakutikas: :gakutika], questions: :company) }
    # scope :eager_loading, -> { eager_load(user_and_companies: [:company, user_and_company_and_gakutikas: :gakutika], questions: :company) }
    # scope :particular_user_and_company_and_gakutikas2, -> (user_id) { where(user_and_company_and_gakutikas: [user_and_companies: {user: user_id } ] ) }
end
