class Api::QuestionsController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler

  before_action :set_company, only: [:create, :update]
  before_action :is_question_of_user, only: [:update, :destroy]

  def create
   
    # @company = Company.find_or_initialize_by(name: question_params[:company_name])
    '''
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    '''
    # @question = @company.questions.build(question_params_for_save)
    @question = Question.new(question_params_for_save)

    if @question.save 
      @user_and_company_and_gakutika = UserAndCompanyAndGakutika.find_or_initialize_by(user_and_company_id: @user_and_company.id, gakutika_id: @question.gakutika_id)
      @user_and_company_and_gakutika.save
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { message: @question.errors.full_messages }, status: :bad_request
    end
  end

  def update
    # @company = Company.find_or_initialize_by(name: question_params[:company_name])
    '''
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    '''

    if @question.update(question_params_for_save)
      render json: @question, serializer: QuestionSerializer, status: :accepted
    else
      render json: { message: @question.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
   
    @question.destroy
    render status: :no_content
  end

  private
    
    def set_company
      @company = Company.find_or_initialize_by(name: question_params[:company_name])
      unless @company.save
        render json: { message: @company.errors.full_messages }, status: :bad_request and return
      end
      @user_and_company = UserAndCompany.find_or_initialize_by(company_id: @company.id, user_id: signin_user(request.headers).id)
      @user_and_company.save
    end

    def question_params_for_save
      question_params_for_save = question_params.to_h
      question_params_for_save[:day] = Date.strptime(question_params[:day], '%Y-%m-%d')
      question_params_for_save.delete(:company_name)
      question_params_for_save[:company_id] = @company.id
      return question_params_for_save
    end
    def question_params
      params.require(:question).permit(:query, :answer, :company_name, :day, :gakutika_id)
    end

    def is_question_of_user
      @question = Question.find_by(id: params[:id])
      correct_user_flag = @question&.gakutika&.user&.id == signin_user(request.headers).id
      render json: { message: ['該当する質問が存在しません'] }, status: :bad_request unless correct_user_flag
    end
end
