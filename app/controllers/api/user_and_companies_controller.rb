class Api::UserAndCompaniesController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :correct_user, only: [:destroy, :update]

  def destroy
    puts @user_and_company.user.name
    puts @user_and_company.company.name
    # Question.destroy_by(user: @user_and_company.user.id, company: @user_and_company.company.id)
    questions = Question.where(company: @user_and_company.company.id)
    questions.each do |q|
      # puts question_id
      # q = Question.find(question_id)
      q.destroy if q.user.id == @user_and_company.user.id
    end
    @user_and_company.destroy
    
    render status: :no_content
  end

  def update

    @company = Company.find_or_initialize_by(name: user_and_company_params[:company_name])
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    questions = Question.where(company: @user_and_company.company.id)
    questions.each do |q|
      q.update(company_id: @company.id) if q.user.id == @user_and_company.user.id
    end
    @user_and_company.update(company_id: @company.id)
    puts @user_and_company.company.name
    render status: :accepted

  end

  private
    def correct_user
      @user_and_company = UserAndCompany.eager_load(:user).find_by!(id: params[:id])
      render json: { message: ['該当する企業が存在しません'] }, status: :bad_request unless @user_and_company.user.id == signin_user(request.headers).id
    end

    def user_and_company_params
      params.require(:user_and_company).permit(:company_name)
    end
    
end
