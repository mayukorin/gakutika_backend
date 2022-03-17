require 'rails_helper'

RSpec.describe "Api::Gakutika::SearchByTitles", type: :request do
    describe "#index" do
        context "通常" do
            let!(:user) do
                FactoryBot.create(:user)
            end
            let!(:token) do
                exp = Time.now.to_i + (4 * 60) 
                TokenProvider.new.call(user_id: user.id, exp: exp)
            end
            let!(:gakutika) do
                user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
            end

            it '[aaaaaa] を返す' do
                get api_gakutika_search_by_title_index_path, headers: { "Authorization" => "JWT " + token }, params: {title: "aaaaa"}
                # expect(response).to have_http_status(:ok)
                puts JSON.parse(response.body)
            end

        end
    end
end
