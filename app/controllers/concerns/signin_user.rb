module SigninUser
    
    extend ActiveSupport::Concern

    def signin_user(request_headers)
        @signin_user ||= UserAuthenticator.call(request_headers)
        raise Application::AuthenticationError unless @signin_user
        return @signin_user
    end
end