class UserAndCompanyAndGakutikaSerializer < ActiveModel::Serializer
    # belongs_to :user_and_company, serializer: UserAndCompanySerializer  
    belongs_to :gakutika, serializer: GakutikaSerializer, show_gakutika_detail_flag: false
    has_many :questions, serializer: QuestionSerializer, if: :show_question_flag
    attributes :id
    attribute :company_name

    def show_question_flag
        @instance_options[:show_question_flag] == true
    end

    def company_name
        object.company.name
    end

end