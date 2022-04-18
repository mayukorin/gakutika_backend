class Api::UserAndCompanyAndGakutikasController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :is_user_and_company_and_gakutika_of_signin_user, only: [:destroy]
  before_action :is_gakutika_of_signin_user, only: [:create]
  def destroy
    @user_and_company_and_gakutika = find_user_and_company_and_gakutika(params[:id])
    @user_and_company_and_gakutika.destroy
    render status: :no_content
  end

  def create
    '''
    @company = Company.find_or_create_by!(name: user_and_company_and_gakutika_params[:company_name])
    @user_and_company = UserAndCompany.create_with(latest_interview_day: user_and_company_and_gakutika_params[:latest_interview_day]).find_or_create_by!(user_id: signin_user(request.headers).id, company_id: @company.id)
    @gakutika = find_gakutika(user_and_company_and_gakutika_params[:gakutika_title])
    '''
    @user_and_company_and_gakutika = UserAndCompanyAndGakutika.create!(gakutika_id: user_and_company_and_gakutika_params[:gakutika_id], user_and_company_id: user_and_company_and_gakutika_params[:user_and_company_id])
    render json: @user_and_company_and_gakutika, serializer: UserAndCompanyAndGakutikaSerializer, status: :created

    
  end

  private

    def find_user_and_company_and_gakutika(user_and_company_and_gakutika_id)

      user_and_company_and_gakutika = UserAndCompanyAndGakutika.eager_load(:user).find_by(id: user_and_company_and_gakutika_id)

    end

    def is_user_and_company_and_gakutika_of_signin_user
      
      user_and_company_and_gakutika = UserAndCompanyAndGakutika.eager_load(:user).find_by(id: params[:id])
      render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request and return unless user_and_company_and_gakutika.user.id == signin_user(request.headers).id
      
    end
    
    def user_and_company_and_gakutika_params
      params.require(:user_and_company_and_gakutika).permit(:user_and_company_id, :gakutika_id)
    end

    def find_gakutika(gakutika_title)
      gakutika = Gakutika.find_by!(title: gakutika_title)
    end

    def is_gakutika_of_signin_user
      gakutika = Gakutika.find_by(title: user_and_company_and_gakutika_params[:gakutika_title])
      render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request unless gakutika&.user&.id == signin_user(request.headers).id
    end
end
