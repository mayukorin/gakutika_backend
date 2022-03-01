require 'rails_helper'

RSpec.describe "Api::UserAndCompanies", type: :request do

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
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end
        let!(:question2) do
          Question.create(query: "質問内容2", answer: "解答2", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
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

    describe "#update" do
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
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end
        it 'status accepted を返す' do
          patch api_user_and_company_path(user_and_company.id), headers: { "Authorization" => "JWT " + token }, params: { user_and_company: { company_name: "abc", latest_interview_day: "2021-11-04" } }
          expect(response).to have_http_status(:accepted)
          expect(user_and_company.reload.company.name).to match("abc")
        end
      end  
    end

    describe "#create" do
      context "通常" do
        let!(:user2) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user2.id, exp: exp)
        end
        it 'status created を返す' do
          user = User.find(user2.id)
          post api_user_and_companies_path, headers: { "Authorization" => "JWT " + token }, params: { user_and_company: { company_name: "abc", latest_interview_day: "2021-11-04" } }
          puts JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          
          # expected_response = {"id"=>5, "company"=>{"name"=>"abc"}, "user_and_company_and_gakutikas"=>[]}
          # expect(JSON.parse(response.body)).to match(expected_response)
        end
      end 
      context "latest_interview_day が nil でもよい" do
        let!(:user2) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user2.id, exp: exp)
        end
        it 'status created を返す' do
          user = User.find(user2.id)
          post api_user_and_companies_path, headers: { "Authorization" => "JWT " + token }, params: { user_and_company: { company_name: "abc", latest_interview_day: nil } }
          puts JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          
          # expected_response = {"id"=>5, "company"=>{"name"=>"abc"}, "user_and_company_and_gakutikas"=>[]}
          # expect(JSON.parse(response.body)).to match(expected_response)
        end
      end 
      context "latest_interview_day が 空白 でもよい" do
        let!(:user2) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user2.id, exp: exp)
        end
        it 'status created を返す' do
          user = User.find(user2.id)
          post api_user_and_companies_path, headers: { "Authorization" => "JWT " + token }, params: { user_and_company: { company_name: "abc", latest_interview_day: "" } }
          puts JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          
          # expected_response = {"id"=>5, "company"=>{"name"=>"abc"}, "user_and_company_and_gakutikas"=>[]}
          # expect(JSON.parse(response.body)).to match(expected_response)
        end
      end 
      context "latest_interview_day が param に存在しない場合" do
        let!(:user2) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user2.id, exp: exp)
        end
        it 'status created を返す' do
          user = User.find(user2.id)
          post api_user_and_companies_path, headers: { "Authorization" => "JWT " + token }, params: { user_and_company: { company_name: "abc" } }
          puts JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          
          # expected_response = {"id"=>5, "company"=>{"name"=>"abc"}, "user_and_company_and_gakutikas"=>[]}
          # expect(JSON.parse(response.body)).to match(expected_response)
        end
      end 
      context "company_name が入力されていない" do
        let!(:user) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end
        it 'status bad request を返す' do
          post api_user_and_companies_path, headers: { "Authorization" => "JWT " + token }, params: { user_and_company: { company_name: "" } }
          expect(response).to have_http_status(:bad_request)
          puts JSON.parse(response.body)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end  
    end

  end

end
