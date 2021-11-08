module ExceptionHandler

extend ActiveSupport::Concern

included do
    rescue_from Application::AuthenticationError, with: :not_authenticated
end

private

def not_authenticated
    render json: { message: [ 'ログインをやり直してください'] }, status: :unauthorized 
end

end