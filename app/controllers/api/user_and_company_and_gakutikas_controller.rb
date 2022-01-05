class Api::UserAndCompanyAndGakutikasController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :correct_user, only: [:destroy]
  def destroy
    Question.destroy_by(gakutika: @user_and_company_and_gakutika.gakutika.id, company: @user_and_company_and_gakutika.company.id)
    @user_and_company_and_gakutika.destroy
    render status: :no_content
  end

  private
    def correct_user
      
      @user_and_company_and_gakutika = UserAndCompanyAndGakutika.eager_load(:user).find_by(id: params[:id])
     
      render json: { message: ['該当する学チカが存在しません'] }, status: :bad_request unless @user_and_company_and_gakutika.user.id == signin_user(request.headers).id
    end
end
