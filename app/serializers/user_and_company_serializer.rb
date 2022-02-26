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
        unless @instance_options[:gakutika_id].nil? 
           # 余計な クエリ発行をさける
           normal_hash = {}
            object.user_and_company_and_gakutikas.each do |user_and_company_and_gakutika| 
                if user_and_company_and_gakutika.gakutika_id == @instance_options[:gakutika_id] 
                    normal_hash[:id] = user_and_company_and_gakutika.id
                    normal_hash[:questions] = user_and_company_and_gakutika.questions
                    return normal_hash
                end
            end
        end
    end
end