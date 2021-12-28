class UserAndCompanySerializer < ActiveModel::Serializer
    belongs_to :company, serializer: CompanySerializer
    has_many :user_and_company_and_gakutikas, serializer: UserAndCompanyAndGakutikaSerializer
end