class UserAuthenticator

    include Service

    def call(request_headers)
        begin 
            puts "auth"
            @request_headers = request_headers
            puts token
            payload, = TokenDecryptor.call(token)
            puts "llllllll"
            puts payload['user_id']
            user = User.find(payload['user_id'])
        rescue StandardError
            puts "ppppppp"
            nil
        end
    end

    private
        def token
            @request_headers['Authorization'].split(' ').last
        end

end