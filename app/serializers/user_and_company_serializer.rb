class UserAndCompanySerializer < ActiveModel::Serializer
    belongs_to :company, serializer: CompanySerializer
    has_many :gakutikas, serializer: GakutikaSerializer 
end