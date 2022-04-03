require 'rails_helper'

RSpec.describe "Api::UserAndCompanyAndGakutika::SearchByCompanyNameAndUserId", type: :request do
    describe "SearchByCompanyNameAndUserId" do
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
                let!(:company) do
                    Company.create(name: "あいう")
                end
                let!(:user_and_company) do
                    UserAndCompany.create(company_id: company.id, user_id: user.id)
                end
                let!(:user_and_company_and_gakutika) do
                    UserAndCompanyAndGakutika.create!(gakutika_id: gakutika.id, user_and_company_id: user_and_company.id)
                end

                it 'status okを返す' do
                    get api_user_and_company_and_gakutika_search_by_company_name_and_user_id_index_path(name: "あい"), headers: { "Authorization" => "JWT " + token }
                    puts JSON.parse(response.body)
                    expect(response).to have_http_status(:ok)
                end
            end
        end
    end
end
