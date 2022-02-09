class Api::UserAndCompanyAndGakutikasController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :correct_user, only: [:destroy]
  before_action :correct_user2, only: [:create]
  def destroy
    Question.destroy_by(gakutika_id: @user_and_company_and_gakutika.gakutika.id, company_id: @user_and_company_and_gakutika.company.id)
    @user_and_company_and_gakutika.destroy
    render status: :no_content
  end

  def create
    @company = Company.find_or_create_by(name: user_and_company_and_gakutika_params[:company_name])
    unless @company.save
      # company_name が空白の時
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    @user_and_company = @company.user_and_companies.find_or_create_by(user_id: signin_user(request.headers).id)
    @user_and_company_and_gakutika = @user_and_company.user_and_company_and_gakutikas.build(gakutika_id: @gakutika.id)

    if @user_and_company_and_gakutika.save
      render json: @user_and_company_and_gakutika, serializer: UserAndCompanyAndGakutikaSerializer, status: :created
    else
      render json: { message: @user_and_company_and_gakutika.errors.full_messages }, status: :bad_request
    end

    
  end

  private
    def correct_user
      
      @user_and_company_and_gakutika = UserAndCompanyAndGakutika.eager_load(:user).find_by!(id: params[:id])
     
      render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request unless @user_and_company_and_gakutika.user.id == signin_user(request.headers).id
    end
    
    def user_and_company_and_gakutika_params
      params.require(:user_and_company_and_gakutika).permit(:company_name, :gakutika_title)
    end

    def correct_user2
      # gakutika_title が入力されていない時は，学チカのタイトルを入力してくださいにしたいと思ったけど，該当のものが~ でよいか
      # gakutika_title が存在しない時は，該当のものが存在しません，になる
      @gakutika = Gakutika.find_by!(title: user_and_company_and_gakutika_params[:gakutika_title])
      render json: { message: ['不正な入力です'] }, status: :bad_request unless @gakutika.user.id == signin_user(request.headers).id
    end
end
