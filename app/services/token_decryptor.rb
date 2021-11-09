class TokenDecryptor

    include Service

    def call(token)
        decrypt(token)
    end

    private
    def decrypt(token)
        begin
            JWT.decode(token, Rails.application.credentials.secret_key_base)
        rescue JWT::ExpiredSignature
            puts "ログインの有効期限切れ"
            raise StandardError
        rescue JWT::VerificationError
            puts "不正なtoken"
            raise StandardError
        end
    end
end
