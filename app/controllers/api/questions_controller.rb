class Api::QuestionsController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler

  before_action :is_question_of_user, only: [:update, :destroy]
  # before_action :set_company, only: [:create, :update]

  def create
  
    @company = find_or_create_company(question_params[:company_name])
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end

    @question = Question.new(question_params_for_save(@company.id, question_params[:gakutika_id]))
    if @question.save 
      @user_and_company = find_or_create_user_and_company(@company.id)
      @user_and_company_and_gakutika = find_or_create_user_and_company_and_gakutika(@user_and_company.id, question_params[:gakutika_id])
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      @company.destroy 
      render json: { message: @question.errors.full_messages }, status: :bad_request
    end
    '''
    @company = find_or_create_company(question_params[:company_name])
    @question = @company.questions.build(question_params_for_save2(question_params[:gakutika_id]))

    if @company.save
      @user_and_company = find_or_create_user_and_company(@company.id)
      @user_and_company_and_gakutika = find_or_create_user_and_company_and_gakutika(@user_and_company.id, question_params[:gakutika_id])
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: { message: @company.errors.full_messages }, status: :bad_request
    end
    '''
   
  end

  def update
   
    @question = find_question(params[:id])
    company_name = question_params[:company_name].to_s == '' ? @question&.company&.name : question_params[:company_name]
    @company = find_or_create_company(company_name)
    unless @company.save
      render json: { message: @company.errors.full_messages }, status: :bad_request and return
    end
    unless @company.name == @question.company.name
      new_company_flag = true
    end
    gakutika_id = question_params[:gakutika_id].to_s == '' ? @question&.gakutika&.id : question_params[:gakutika_id]

    if @question.update(question_params_for_save(@company.id, gakutika_id))
      @user_and_company = find_or_create_user_and_company(@company.id)
      @user_and_company_and_gakutika = find_or_create_user_and_company_and_gakutika(@user_and_company.id, gakutika_id)
      render json: @question, serializer: QuestionSerializer, status: :accepted
    else
      if new_company_flag
        @company.destroy 
      end
      render json: { message: @question.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @question = find_question(params[:id])
    @question.destroy
    render status: :no_content
  end

  private
    
    def set_company
      
      company_name = question_params[:company_name].to_s == '' ? @question&.company&.name : question_params[:company_name]
      gakutika_id = question_params[:gakutika_id].to_s == '' ? @question&.gakutika&.id : question_params[:gakutika_id]
      
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

    def find_or_create_company(company_name)
      company = Company.find_or_initialize_by(name: company_name)
      return company
    end

    def find_or_create_user_and_company(company_id)

      user_and_company = UserAndCompany.find_or_create_by(company_id: company_id, user_id: signin_user(request.headers).id)
      return user_and_company
    end

    def find_or_create_user_and_company_and_gakutika(user_and_company_id, gakutika_id)

      user_and_company_and_gakutika = UserAndCompanyAndGakutika.find_or_create_by(user_and_company_id: user_and_company_id, gakutika_id: gakutika_id)
      return user_and_company_and_gakutika
    end



    def question_params_for_save(company_id, gakutika_id)
      question_params_for_save = question_params.to_h
      # ここで error になると，company が消されない
      # puts question_params[:day]
      # question_params_for_save[:day] = Date.strptime(question_params[:day], '%Y-%m-%d')
      question_params_for_save.delete(:company_name)
     
      question_params_for_save[:company_id] = company_id
      question_params_for_save[:gakutika_id] = gakutika_id
      return question_params_for_save
    end

    def question_params_for_save2(gakutika_id)
      question_params_for_save = question_params.to_h
      # ここで error になると，company が消されない
      # puts question_params[:day]
      # question_params_for_save[:day] = Date.strptime(question_params[:day], '%Y-%m-%d')
      question_params_for_save.delete(:company_name)
    
      question_params_for_save[:gakutika_id] = gakutika_id
      return question_params_for_save
    end

    def question_params
      params.require(:question).permit(:query, :answer, :company_name, :day, :gakutika_id)
    end

    def is_question_of_user
      question = Question.find_by(id: params[:id])
      render json: { message: ['該当する質問が存在しません'] }, status: :bad_request unless question&.gakutika&.user&.id == signin_user(request.headers).id
    end

    def find_question(question_id)
      question = Question.find_by!(question_id)
    end
end
