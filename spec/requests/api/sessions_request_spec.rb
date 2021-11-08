require 'rails_helper'

RSpec.describe "Api::Sessions", type: :request do
    describe "Session" do

        describe "#create" do
    
    
          context "メールアドレスとパスワードが合っている場合" do
            let!(:user) do
              FactoryBot.create(:user)
            end
            it 'status ok を返す' do
              post api_signin_path, params: { session: { email: "abcdef@example.com", password: "password" } }
              expect(response).to have_http_status(:ok)
            end
          end
    
          context "メールアドレスが間違っている場合" do
            let!(:user) do
              FactoryBot.create(:user)
            end
            it 'status unauthorized と「メールアドレスかパスワードが間違っています」メッセージを返す' do
              post api_signin_path, params: { session: { email: "abcde@example.com", password: "password" } }
              expect(response).to have_http_status(:unauthorized)
              expected_response = { 'message' => ['メールアドレスかパスワードが間違っています'] }
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end
    
          context "パスワードが間違っている場合" do
            let!(:user) do
              FactoryBot.create(:user)
            end
            it 'status unauthorized と「メールアドレスかパスワードが間違っています」メッセージを返す' do
              post api_signin_path, params: { session: { email: "abcdef@example.com", password: "passwor" } }
              expect(response).to have_http_status(:unauthorized)
              expected_response = { 'message' => ['メールアドレスかパスワードが間違っています'] }
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end
    
        end
    
        describe "#me" do
          let!(:user) do
            FactoryBot.create(:user)
          end
          let!(:token) do
            exp = Time.now.to_i + 4 * 60
            TokenProvider.new.call(user_id: user.id, exp: exp)
          end
          context "TokenProviderで生成したtokenがヘッダーに含まれている場合" do
            it "status ok と user を返す" do
              get api_me_path, headers: { "Authorization" => "JWT " + token }
              expect(response).to have_http_status(:ok)
              expected_response = {'name' => user.name, 'email' => user.email}
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end
    
          context "TokenProviderで生成したtokenと異なるものがヘッダーに含まれている場合" do
            it "status unauthorized  と 「ログインをやり直してください」メッセージ を返す" do
              get api_me_path, headers: { "Authorization" => "JWT " + token + "aa"}
              expect(response).to have_http_status(:unauthorized)
              expected_response = { 'message' => ['ログインをやり直してください'] }
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end
    
          context "tokenがヘッダーに含まれていない場合" do
            it "status unauthorized  と 「ログインをやり直してください」メッセージ を返す" do
              get api_me_path
              expect(response).to have_http_status(:unauthorized)
              expected_response = { 'message' => ['ログインをやり直してください'] }
              expect(JSON.parse(response.body)).to match(expected_response)
            end
          end
    
        end
    end
end
