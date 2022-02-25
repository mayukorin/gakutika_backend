class Api::UserAndCompaniesController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler 
  before_action :correct_user, only: [:destroy, :update]

  def destroy
   
    @user_and_company = find_user_and_company(params[:id])
    questions = Question.where(company: @user_and_company.company.id)
    questions.each do |q|
      # puts question_id
      # q = Question.find(question_id)
      q.destroy if q.user.id == @user_and_company.user.id
    end
    @user_and_company.destroy
    
    render status: :no_content
  end

  def index
    # @user_and_companies = UserAndCompany.includes(:company, :user_and_company_and_gakutikas).where(user_id: signin_user(request.headers).id)
    @user_and_companies = UserAndCompany.pre_loading.where(user_id: signin_user(request.headers).id)
    render json: @user_and_companies, each_serializer: UserAndCompanySerializer, include: [:company, user_and_company_and_gakutikas: :gakutika], show_gakutika_detail_flag: true, status: :ok
  end

  def update
    '''
    @user_and_company = find_user_and_company(params[:id])
    @company = Company.find_or_initialize_by(name: user_and_company_params[:company_name])
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    questions = Question.where(company_id: @user_and_company.company.id)
    questions.each do |q|
      q.update(company_id: @company.id) if q.user.id == @user_and_company.user.id
    end
    @user_and_company.update(company_id: @company.id)
    puts @user_and_company.company.name
    render status: :accepted
    '''
    @user_and_company = find_user_and_company(params[:id])
    @company = Company.find_or_create_by!(name: user_and_company_params[:company_name])
    @user_and_company.update!(company_id: @company.id)
    questions = Question.where(company_id: @user_and_company.company.id)
    questions.each do |q|
      q.update(company_id: @company.id) if q.user.id == @user_and_company.user.id
    end
    render status: :accepted
  end

  def create
    '''
    @company = Company.find_or_initialize_by(name: user_and_company_params[:company_name])
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    @user_and_company = UserAndCompany.new(company_id: @company.id, user_id: signin_user(request.headers).id)
    if @user_and_company.save
      render json: @user_and_company, serializer: UserAndCompanySerializer, status: :created
    else
      render json: { message: @user_and_company.errors.full_messages }, status: :bad_request
    end
    '''
    @company = Company.find_or_create_by!(name: user_and_company_params[:company_name])
    @user_and_company = UserAndCompany.create!(user_id: signin_user(request.headers).id, company_id: @company.id)
    render json: @user_and_company, serializer: UserAndCompanySerializer, status: :created
  end

  private
    def correct_user
      user_and_company = UserAndCompany.eager_load(:user).find_by!(id: params[:id])
      render json: { message: ['該当する企業が存在しません'] }, status: :bad_request unless user_and_company.user.id == signin_user(request.headers).id
    end

    def find_user_and_company(user_and_company_id)
      user_and_company = UserAndCompany.eager_load(:user).find_by!(id: user_and_company_id)
    end
    def user_and_company_params
      params.require(:user_and_company).permit(:company_name)
    end
    
end
