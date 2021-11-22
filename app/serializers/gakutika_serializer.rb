class GakutikaSerializer < ActiveModel::Serializer
    attributes :id, :title, :content
    attribute :tough_rank, key: :toughRank
    attributes :startMonth
    attributes :endMonth

    def startMonth
      object.start_month.strftime("%Y-%m")
    end

    def endMonth
      object.end_month.strftime("%Y-%m")
    end

  end
  