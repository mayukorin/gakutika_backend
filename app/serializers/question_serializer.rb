class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :query, :answer
  attribute :day
  attribute :companyName

  def day
    object.day.strftime("%Y-%m-%d")
  end

  def companyName
    object.user_and_company_and_gakutika.user_and_company.company.name
  end
end
