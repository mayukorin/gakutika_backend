class UserAndCompanySerializer < ActiveModel::Serializer
    attribute :id
    belongs_to :company
    has_many :user_and_company_and_gakutikas
    attribute :user_and_company_and_particular_gakutika
    '''
    def company
        CompanySerializer.new(object.company)
    end

    def user_and_company_and_gakutikas
        UserAndCompanyAndGakutikaSerializer.new(object.user_and_company_and_gakutikas.first)
    end
    '''

    def user_and_company_and_particular_gakutika
        puts "user_and_company_pg"
        puts @instance_options[:gakutika_id]
        unless @instance_options[:gakutika_id].nil?
            object.user_and_company_and_gakutikas.find_by(gakutika_id: @instance_options[:gakutika_id])
        end
    end
end