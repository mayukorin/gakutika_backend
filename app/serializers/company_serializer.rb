class CompanySerializer < ActiveModel::Serializer
    attribute :name
    # has_many :gakutikas, serializer: GakutikaSerializer 

    '''
    def gakutikas
        user_and_company = UserAndCompany.find_by(user_id: @instance_options[:user_id], company_id: object.id)
        return user_and_company.gakutikas
    end
    '''
end