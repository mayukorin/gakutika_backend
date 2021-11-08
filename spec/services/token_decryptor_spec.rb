require 'rails_helper'

RSpec.describe "TokenDecryptor", type: :model do
    describe "#call" do
        let!(:user) do
            FactoryBot.create(:user)
        end
        context "TokenProviderで生成したtokenを引数として呼び出す場合" do
            
            let!(:token) do
                exp = Time.now.to_i + 4 * 60
                TokenProvider.new.call(user_id: user.id, exp: exp)
            end
            
            it "戻り値に含まれるuser_idがTokenProviderで生成した時に指定したuser.idと等しい" do
                payload, = TokenDecryptor.new.call(token)
                expect(payload["user_id"]).to match(user.id)
            end
        end

        context "TokenProviderで生成したtokenでないものを引数として呼び出す場合" do
            
            let!(:token) do
                exp = Time.now.to_i + 4 * 60
                TokenProvider.new.call(user_id: user.id, exp: exp) + "aaaa"
            end
            
            it "StandardErrorが発生" do
                expect do
                    TokenDecryptor.new.call(token)
                end.to raise_error(StandardError)
            end
        end
        
    end
end