require 'rails_helper'

RSpec.describe "UserAuthenticator", type: :model do
    describe "#call" do
        let!(:user) do
            FactoryBot.create(:user)
        end
        let!(:token) do
            exp = Time.now.to_i + (4 * 60)
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end

        context "TokenProviderで生成したtokenがヘッダーに含まれている場合" do
            it "userモデルを返して，かつtokenを生成するときに指定したユーザidを持つユーザを返す" do
                request_headers = { "Authorization" => "JWT " + token }
                return_user = UserAuthenticator.new.call(request_headers)
                expect(return_user.id).to match(user.id)
            end
        end

        context "TokenProviderで生成したtokenとは違うものがヘッダーに含まれている場合" do
            it "nilを返す" do
                request_headers = { "Authorization" => "JWT aa" }
                return_user = UserAuthenticator.new.call(request_headers)
                expect(return_user).to be_nil
            end
        end

        context "Authorizationに紐づくtokenがヘッダーに含まれていない場合" do
            it "nilを返す" do
                request_headers = { "A" => "JWT aa" }
                return_user = UserAuthenticator.new.call(request_headers)
                expect(return_user).to be_nil
            end
        end
    end
end