class Api::QuestionsController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler

  before_action :is_question_of_user, only: [:update, :destroy]
  before_action :set_company, only: [:create, :update]

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
      # @user_and_company_and_gakutika = UserAndCompanyAndGakutika.find_or_initialize_by(user_and_company_id: @user_and_company.id, gakutika_id: @question.gakutika_id)
      # @user_and_company_and_gakutika.save
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      @company.destroy # user_and_company も，user_and_company_and_gakutikasも全部消される
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
    if @company.name != @question.company.name
      new_company_flag = true
    end

    if @question.update(question_params_for_save)
      render json: @question, serializer: QuestionSerializer, status: :accepted
    else
      if new_company_flag # 新しい company を作ろうとしていたら
        @company.destroy 
      end
      render json: { message: @question.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
   
    @question.destroy
    render status: :no_content
  end

  private
    
    def set_company
      
      company_name = question_params[:company_name]
      if company_name.to_s == '' and !@question.nil? 
        company_name = @question.company.name
      end

      gakutika_id = question_params[:gakutika_id]
      if gakutika_id.to_s == '' and !@question.nil? 
        gakutika_id = @question.gakutika.id
      end
      
      @company = Company.find_or_initialize_by(name: company_name)
      unless @company.save
        render json: { message: @company.errors.full_messages }, status: :bad_request and return
      end
      @user_and_company = UserAndCompany.find_or_initialize_by(company_id: @company.id, user_id: signin_user(request.headers).id)
      unless @user_and_company.save
        @company.destroy
        render json: { message: @user_and_company.errors.full_messages }, status: :bad_request and return
      end
      @user_and_company_and_gakutika = UserAndCompanyAndGakutika.find_or_initialize_by(user_and_company_id: @user_and_company.id, gakutika_id: question_params[:gakutika_id])
      unless @user_and_company_and_gakutika.save
        @company.destroy
        render json: { message: @user_and_company_and_gakutika.errors.full_messages }, status: :bad_request and return
      end
    end

    def question_params_for_save
      question_params_for_save = question_params.to_h
      # ここで error になると，company が消されない
      # puts question_params[:day]
      # question_params_for_save[:day] = Date.strptime(question_params[:day], '%Y-%m-%d')
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
