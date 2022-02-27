class GakutikaSerializer < ActiveModel::Serializer
    attributes :id, :title, :content
    attribute :tough_rank, key: :toughRank
    attribute :startMonth
    attribute :endMonth
    has_many :questions, serializer: QuestionSerializer, if: :show_gakutika_detail
    # has_many :user_and_company_and_gakutikas, serializer: UserAndCompanyAndGakutikaSerializer, if: -> { show_gakutika_detail }
    has_many :user_and_companies, serializer: UserAndCompanySerializer, gakutika_id: :gakutika_id, if: :show_gakutika_detail
    # has_many :user_and_company_and_gakutikas, serializer: UserAndCompanyAndGakutikaSerializer
    # has_many :companies, serializer: CompanySerializer, if: -> { show_gakutika_detail }
    # attribute :particular_user_and_company_and_gakutikas


    def startMonth
      object.start_month.strftime("%Y-%m")
    end

    def endMonth
      object.end_month.strftime("%Y-%m")
    end

    def show_gakutika_detail
      @instance_options[:show_gakutika_detail_flag] == true
    end

    '''
    def particular_user_and_company_and_gakutikas
      puts "trial"
      unless @instance_options[:user_id].nil?
        puts "ok"
        puts object.user_and_company_and_gakutikas
        puts "abc"
        object.user_and_company_and_gakutikas.eager_load(:user_and_company) # できない... joinで怒られる，eager_load だといける
        puts "cba"
        object.user_and_company_and_gakutikas.eager_load(:user_and_company).where(user_and_companies: {user: @instance_options[:user_id]})
      end
      
    end
    '''

    

  end
  