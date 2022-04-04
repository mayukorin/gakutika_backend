class Gakutika < ApplicationRecord

    include SigninUser

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

    after_create :create_default_user_and_company_and_gakutika

    private
        def create_default_user_and_company_and_gakutika
          
            @default_company = Company.find_or_create_by(name: "予想される質問")
            @user_and_default_company = UserAndCompany.find_or_create_by(user_id: self.user.id, company_id: @default_company.id)
            @user_and_company_and_gakutika = UserAndCompanyAndGakutika.create(gakutika_id: self.id, user_and_company_id: @user_and_default_company.id)
        end
end
