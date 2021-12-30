class GakutikaSerializer < ActiveModel::Serializer
    attributes :id, :title, :content
    attribute :tough_rank, key: :toughRank
    attributes :startMonth
    attributes :endMonth
    has_many :questions, serializer: QuestionSerializer, if: -> { show_gakutika_detail }
    # has_many :user_and_company_and_gakutikas, serializer: UserAndCompanyAndGakutikaSerializer, if: -> { show_gakutika_detail }
    has_many :user_and_companies, serializer: UserAndCompanySerializer
    # has_many :companies, serializer: CompanySerializer, if: -> { show_gakutika_detail }


    def startMonth
      object.start_month.strftime("%Y-%m")
    end

    def endMonth
      object.end_month.strftime("%Y-%m")
    end

    def show_gakutika_detail
      @instance_options[:show_gakutika_detail_flag] == true
    end

    

  end
  