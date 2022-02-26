class UserAndCompanyAndGakutikaSerializer < ActiveModel::Serializer
    # belongs_to :user_and_company, serializer: UserAndCompanySerializer  
    belongs_to :gakutika, serializer: GakutikaSerializer, show_gakutika_detail_flag: false
    # has_many :questions, serializer: QuestionSerializer
    attributes :id
    # has_one :company

end