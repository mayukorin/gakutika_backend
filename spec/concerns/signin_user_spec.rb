require 'rails_helper'
include SigninUser

RSpec.describe "SigninUser", type: :controller do
    describe "#signin_user" do
        let!(:user) do
            FactoryBot.create(:user)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end

        context "TokenProviderで生成したtokenがヘッダーに含まれている場合" do
            
            it "userモデルを返して，かつtokenを生成するときに指定したユーザidを持つユーザを返す" do
                request_headers = { "Authorization" => "JWT " + token }
                return_user = signin_user(request_headers)
                expect(return_user.id).to match(user.id)
            end
        end
    end
end