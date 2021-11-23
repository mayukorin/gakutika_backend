class Api::QuestionsController < ApplicationController
  include Service
  include SigninUser
  include ExceptionHandler

  def create
    @company = Company.find_or_create_by(name: question_params[:company_name])
    @question = @company.questions.build(question_params_for_save)
    
    if @question.save 
      render json: @question, serializer: QuestionSerializer, status: :created
    else
      render json: @question.errors, status: :bad_request
    end
  end
  private
    
    def question_params_for_save
      question_params_for_save = question_params.to_h
      question_params_for_save[:day] = Date.strptime(question_params[:day], '%Y-%m-%d')
      question_params_for_save.delete(:company_name)
      return question_params_for_save
    end
    def question_params
      params.require(:question).permit(:query, :answer, :company_name, :day, :gakutika_id)
    end
end
