class GakutikaSerializer < ActiveModel::Serializer
    attributes :id, :title, :content
    attribute :tough_rank, key: :toughRank
    attribute :startMonth
    attribute :endMonth
    # has_many :user_and_company_and_gakutikas, serializer: UserAndCompanyAndGakutikaSerializer, if: -> { show_gakutika_detail }
    has_many :user_and_companies, serializer: UserAndCompanySerializer, gakutika_id: :gakutika_id, if: :show_gakutika_detail
    attribute :user_and_default_company_and_gakutika_id, if: :show_gakutika_detail
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

    def user_and_default_company_and_gakutika_id
      @default_company = Company.find_by(name: "予想される質問")
      @user_and_default_company = UserAndCompany.find_or_create_by(user_id: object.user.id, company_id: @default_company.id)
      @user_and_default_company_and_gakutika = UserAndCompanyAndGakutika.find_or_create_by(gakutika_id: object.id, user_and_company_id: @user_and_default_company.id)
      return @user_and_default_company_and_gakutika.id
    end

    '
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
    '

    

  end
  