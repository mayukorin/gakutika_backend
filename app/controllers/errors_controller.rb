class ErrorsController < ActionController::Base

    rescue_from Application::AuthenticationError, with: :not_authenticated
    rescue_from ArgumentError, with: :invalid_input
    rescue_from TypeError, with: :invalid_input
    rescue_from ActiveRecord::RecordNotFound, with: :object_not_found
    # rescue_from ActionController::UrlGenerationError, with: :_not_found
    
    
    def raise_error
        puts "エラ――――"
        raise Rails.application.env['action_dispatch.exception']
    end

    def not_authenticated
        render json: { message: [ 'ログインをやり直してください'] }, status: :unauthorized 
    end
    
    def invalid_input
        render json: { message: ['不正な入力です']}, status: :bad_request
    end
    
    def object_not_found
        render json: { message: ['該当のものが存在しません']}, status: :bad_request
    end


end
