class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :query, :answer, :day, :companyName

  def day
    object.day.strftime("%Y-%m-%d")
  end

  def companyName
    object.company.name
  end
end
