class Api::UserAndCompaniesController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :correct_user, only: [:destroy]

  def destroy
    puts @user_and_company.user.name
    puts @user_and_company.company.name
    # Question.destroy_by(user: @user_and_company.user.id, company: @user_and_company.company.id)
    questions_id = Question.where(company: @user_and_company.company.id)
    questions_id.each do |q|
      # puts question_id
      # q = Question.find(question_id)
      q.destroy if q.user.id == @user_and_company.user.id
    end
    @user_and_company.destroy
    
    render status: :no_content
  end

  private
    def correct_user
      @user_and_company = UserAndCompany.eager_load(:user).find_by!(id: params[:id])
      render json: { message: ['該当する企業が存在しません'] }, status: :bad_request unless @user_and_company.user.id == signin_user(request.headers).id
    end
    
end
