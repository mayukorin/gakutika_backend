class UserAndCompanyAndGakutikaSerializer < ActiveModel::Serializer
    belongs_to :user_and_company, serializer: UserAndCompanySerializer  
    attributes :id, :company_id, :companyName

    def companyName
        object.user_and_company.company.name
    end

    def company_id
        object.user_and_company.company.id
    end
end