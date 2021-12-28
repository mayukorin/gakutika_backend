class CompanySerializer < ActiveModel::Serializer
    attribute :name
    attribute :user_and_company, serializer: UserAndCompanySerializer

    def user_and_company
        user_and_company = UserAndCompany.find_by(user_id: @instance_options[:user_id], company_id: object.id)
    end
    
end