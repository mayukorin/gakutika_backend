class CompanySerializer < ActiveModel::Serializer
    attribute :name
    # attribute :user_and_company, serializer: UserAndCompanySerializer
    # attribute :signin_user_and_company_and_gakutikas, serializer: UserAndCompanyAndGakutikaSerializer
    
    def user_and_company
        user_and_company = UserAndCompany.eager_load(:user_and_company_and_gakutikas).find_by(user_id: @instance_options[:user_id], company_id: object.id)
    end

    def signin_user_and_company_and_gakutikas
        user_and_company = UserAndCompany.find_by(user_id: @instance_options[:user_id], company_id: object.id)
        return user_and_company.user_and_company_and_gakutikas
    end
    
end