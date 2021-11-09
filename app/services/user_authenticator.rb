class UserAuthenticator

    include Service

    def call(request_headers)
        begin 
            @request_headers = request_headers
            payload, = TokenDecryptor.call(token)
            user = User.find(payload['user_id'])
        rescue StandardError => e
            nil
        end
    end

    private
        def token
            @request_headers['Authorization'].split(' ').last
        end

end