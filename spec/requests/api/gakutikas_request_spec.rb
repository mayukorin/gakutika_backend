require 'rails_helper'

RSpec.describe "Api::Gakutikas", type: :request do
    describe "Gakutikas" do
        describe "#index" do
            context "ユーザの学チカ一覧を取得する場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + 4 * 60
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end
                it 'status ok と gakutika 一覧を返す' do
                    gakutika1 = user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb")
                    gakutika2 = user.gakutikas.create(title: "cccccc", content: "bbbbbbbbbbbbbb")
                    puts gakutika1.id
                    puts gakutika2.id
                    puts "aaaaaaaaaaaaa"
                    get api_gakutikas_path, headers: { "Authorization" => "JWT " + token }
                    expect(response).to have_http_status(:ok)
                    puts JSON.parse(response.body)
                    # expected_response = { { 'title' => 'aaaaaa', 'content' => 'bbbbbbbbbbbbbb' } } 
                    # expect(JSON.parse(response.body)).to match(expected_response)
                end
            end
        end
    end
end
