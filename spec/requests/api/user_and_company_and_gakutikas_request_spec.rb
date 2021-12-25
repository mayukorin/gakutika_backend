require 'rails_helper'

RSpec.describe "Api::UserAndCompanyAndGakutikas", type: :request do

  describe "user_and_company_and_gakutikas" do
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
        it 'status no content を返す' do
          # puts user_and_company_and_gakutika.id
          # puts UserAndCompanyAndGakutika.find_by(id: user_and_company_and_gakutika.id)
          puts "what!?"
          puts user.id
          delete api_user_and_company_and_gakutika_path(user_and_company_and_gakutika.id), headers: { "Authorization" => "JWT " + token }
          # puts JSON.parse(response.body)
          expect(response).to have_http_status(:no_content)
          expect(UserAndCompanyAndGakutika.count).to match(0)
        end
      end
    end
  end
end
