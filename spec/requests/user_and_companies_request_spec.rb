require 'rails_helper'

RSpec.describe "UserAndCompanies", type: :request do

  describe "user_and_companies" do
    describe "#destroy" do
      context "通常" do
        let!(:user) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:user_and_company) do
            UserAndCompany.create(company_id: company.id, user_id: user.id)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end
        let!(:gakutika) do
            user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        let(:user_and_company_and_gakutika) do
            UserAndCompanyAndGakutika.create(gakutika_id: gakutika.id, user_and_company_id: user_and_company.id)
        end
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status no content を返す' do
          delete api_user_and_company_path(user_and_company.id), headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:no_content)
          expect(UserAndCompanyAndGakutika.count).to match(0)
          expect(UserAndCompany.count).to match(0)
          expect(Question.count).to match(0)
        end
      end
    end

end
