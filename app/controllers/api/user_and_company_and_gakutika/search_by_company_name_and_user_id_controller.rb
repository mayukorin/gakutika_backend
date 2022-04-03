class Api::UserAndCompanyAndGakutika::SearchByCompanyNameAndUserIdController < ApplicationController
    include Service
    include SigninUser
    include ExceptionHandler

    def index
        @company_id_list = Company.where("name like ?", "#{params[:name]}%").pluck(:id)
        puts params[:name]
        puts @company_id_list
        @user_and_company_id_list = UserAndCompany.where(user_id: signin_user(request.headers).id, company_id: @company_id_list).pluck(:id)
        @user_and_company_and_gakutikas = UserAndCompanyAndGakutika.where(user_and_company_id: @user_and_company_id_list)
        puts @user_and_company_and_gakutikas
        puts "aaa"
        render json: @user_and_company_and_gakutikas, each_serializer: UserAndCompanyAndGakutikaSerializer, show_question_flag: false, status: :ok
    end
end
