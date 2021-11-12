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
                    gakutika1 = user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1)
                    gakutika2 = user.gakutikas.create(title: "cccccc", content: "bbbbbbbbbbbbbb", tough_rank: 2)
                    g1_id = gakutika1.id
                    a = { "#{g1_id}": "2" }
                    puts a
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

    describe "#updateToughRank" do
        context "通常" do
            let!(:user) do
                FactoryBot.create(:user)
            end
            let!(:token) do
                exp = Time.now.to_i + 4 * 60
                TokenProvider.new.call(user_id: user.id, exp: exp)
            end
            it 'status ok と gakutika 一覧を返す' do
                gakutika1 = user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1)
                gakutika2 = user.gakutikas.create(title: "cccccc", content: "bbbbbbbbbbbbbb", tough_rank: 2)
                g1_id = gakutika1.id
                g2_id = gakutika2.id
                post api_updateToughRank_path, headers: { "Authorization" => "JWT " + token }, params: { id_and_new_tough_rank: { "#{g1_id}": "2", "#{g2_id}": "1" } }
                expect(response).to have_http_status(:ok)
                expect(gakutika1.reload.tough_rank).to match(2)
                expect(gakutika2.reload.tough_rank).to match(1)
            end
        end

    end
end
