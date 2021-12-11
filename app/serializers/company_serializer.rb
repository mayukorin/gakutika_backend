class CompanySerializer < ActiveModel::Serializer
    attributes :name
    has_many :gakutikas, serializer: GakutikaSerializer 
end