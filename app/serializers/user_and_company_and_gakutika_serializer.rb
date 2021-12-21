class UserAndCompanyAndGakutikaSerializer < ActiveModel::Serializer
    belongs_to :user_and_company, serializer: UserAndCompanySerializer  
    attributes :id, :company_id, :companyName
    has_one :company

    def companyName
        "aaaa"
    end

    def company_id
        "bbbb"
    end
end