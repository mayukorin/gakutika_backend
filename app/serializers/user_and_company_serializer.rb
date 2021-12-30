class UserAndCompanySerializer < ActiveModel::Serializer
    attribute :id
    belongs_to :company
    has_many :user_and_company_and_gakutikas
    '''
    def company
        CompanySerializer.new(object.company)
    end

    def user_and_company_and_gakutikas
        UserAndCompanyAndGakutikaSerializer.new(object.user_and_company_and_gakutikas.first)
    end
    '''
end