module ExceptionHandler

extend ActiveSupport::Concern

included do
    rescue_from Application::AuthenticationError, with: :not_authenticated
    rescue_from ArgumentError, with: :invalid_input
    rescue_from TypeError, with: :invalid_input
    rescue_from  ActionController::UnpermittedParameters, with: :invalid_input
    rescue_from  ActionController::ParameterMissing, with: :invalid_input
    # rescue_from ActiveRecord::InvalidForeignKey, with: :invalid_input
    rescue_from ActiveRecord::RecordNotFound, with: :object_not_found
    # rescue_from ActionController::UrlGenerationError, with: :object_not_found
end

private

def not_authenticated(e)
    puts e
    render json: { message: [ 'ログインをやり直してください'] }, status: :unauthorized 
end

def invalid_input(e)
    puts e
    render json: { message: ['不正な入力です']}, status: :bad_request
end

def object_not_found(e)
    puts e
    render json: { message: ['該当のものが存在しません']}, status: :bad_request
end

end