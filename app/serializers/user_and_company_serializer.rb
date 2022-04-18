class UserAndCompanySerializer < ActiveModel::Serializer
    attributes :id
    attribute :latest_interview_day 
    belongs_to :company
    attribute :company_name
    has_many :user_and_company_and_gakutikas, show_question_flag: false
    attribute :user_and_company_and_particular_gakutika
    '
    def company
        CompanySerializer.new(object.company)
    end

    def user_and_company_and_gakutikas
        UserAndCompanyAndGakutikaSerializer.new(object.user_and_company_and_gakutikas.first)
    end
    '

    def user_and_company_and_particular_gakutika
        unless @instance_options[:gakutika_id].nil? 
           # 余計な クエリ発行をさける
           user_and_company_and_particular_gakutika = {}
            object.user_and_company_and_gakutikas.each do |user_and_company_and_gakutika| 
                if user_and_company_and_gakutika.gakutika_id == @instance_options[:gakutika_id] 
                    user_and_company_and_particular_gakutika = ActiveModel::SerializableResource.new(user_and_company_and_gakutika, each_serializer: UserAndCompanyAndGakutikaSerializer, show_question_flag: true)
                    return user_and_company_and_particular_gakutika
                end
            end
        end
    end

    def company_name
        object.company.name
    end
end