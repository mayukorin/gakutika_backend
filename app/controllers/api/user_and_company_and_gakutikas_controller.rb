class Api::UserAndCompanyAndGakutikasController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :correct_user, only: [:destroy]
  before_action :correct_user2, only: [:create]
  def destroy
    Question.destroy_by(gakutika: @user_and_company_and_gakutika.gakutika.id, company: @user_and_company_and_gakutika.company.id)
    @user_and_company_and_gakutika.destroy
    render status: :no_content
  end

  def create
    @company = Company.find_or_create_by(name: user_and_company_and_gakutika_params[:company_name])
    @user_and_company = UserAndCompany.create(company_id: @company.id, user_id: signin_user(request.headers).id)
    @user_and_company_and_gakutika = UserAndCompanyAndGakutika.new(user_and_company_id: @user_and_company.id, gakutika_id: @gakutika.id)

    if @user_and_company_and_gakutika.save
      render json: @user_and_company_and_gakutika, serializer: UserAndCompanyAndGakutikaSerializer, status: :created
    else
      render json: { message: @user_and_company_and_gakutika.errors.full_messages }, status: :bad_request
    end

    
  end

  private
    def correct_user
      
      @user_and_company_and_gakutika = UserAndCompanyAndGakutika.eager_load(:user).find_by(id: params[:id])
     
      render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request unless @user_and_company_and_gakutika.user.id == signin_user(request.headers).id
    end

    def user_and_company_and_gakutika_params
      params.require(:user_and_company_and_gakutika).permit(:company_name, :gakutika_id)
    end

    def correct_user2
      @gakutika = Gakutika.find(user_and_company_and_gakutika_params[:gakutika_id])
      render json: { message: ['不正な入力です'] }, status: :bad_request unless @gakutika.user.id == signin_user(request.headers).id
    end
end
