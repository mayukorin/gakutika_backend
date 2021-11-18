class GakutikaSerializer < ActiveModel::Serializer
    attributes :id, :title, :content, :tough_rank
    attributes :startMonth
    attributes :endMonth

    def startMonth
      object.start_month.strftime("%Y-%m")
    end

    def endMonth
      object.end_month.strftime("%Y-%m")
    end

  end
  