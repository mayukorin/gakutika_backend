require 'rails_helper'

RSpec.describe "Api::Companies", type: :request do
    describe "Companies" do
        describe "#index" do
            context "通常" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + 4 * 60
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end
                let!(:gakutika) do
                    user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                end
                let!(:company) do
                  Company.create(name: "あいう")
                end
                let!(:user_and_company) do
                    UserAndCompany.create(user_id: user.id, company_id: company.id)
                end
                let!(:question) do
                  gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
                end
                let!(:user_and_company_and_gakutika) do
                    UserAndCompanyAndGakutika.create(user_and_company_id: user_and_company.id, gakutika_id: gakutika.id)
                end
                let!(:company2) do
                    Company.create(name: "ういあ")
                  end
                  let!(:user_and_company2) do
                      UserAndCompany.create(user_id: user.id, company_id: company2.id)
                  end
                  let!(:user_and_company_and_gakutika2) do
                      UserAndCompanyAndGakutika.create(user_and_company_id: user_and_company2.id, gakutika_id: gakutika.id)
                  end
                it "会社一覧と200を返す" do
                    get api_companies_path, headers: { "Authorization" => "JWT " + token }
                    puts "最新"
                    puts JSON.parse(response.body)
                    expect(response).to have_http_status(:ok)
                end
            end
        end
    end
end