class GakutikaSerializer < ActiveModel::Serializer
    attributes :id, :title, :content
    attribute :tough_rank, key: :toughRank
    attributes :startMonth
    attributes :endMonth
    has_many :questions, serializer: QuestionSerializer, if: -> { show_gakutika_detail }
    attribute :companies, serializer: CompanySerializer

    def startMonth
      object.start_month.strftime("%Y-%m")
    end

    def endMonth
      object.end_month.strftime("%Y-%m")
    end

    def show_gakutika_detail
      @instance_options[:show_gakutika_detail_flag] == true
    end

    def companies
      object.user_and_company_and_gakutikas.user_and_company.company
    end

  end
  