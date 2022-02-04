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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status no content を返す' do
          delete api_user_and_company_and_gakutika_path(user_and_company_and_gakutika.id), headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:no_content)
          expect(UserAndCompanyAndGakutika.count).to match(0)
          expect(Question.count).to match(0)
        end
      end
    end

    describe "#create" do
      context "通常" do
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
        let!(:gakutika) do
            user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        it 'status created を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: "企業A", gakutika_title: gakutika.title }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:created)
        end
      end

      context "gakutika_idで存在しない学チカを指定しているとき" do
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
        let!(:gakutika) do
            user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        it 'status bad request を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: "企業A", gakutika_title: "なし" }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当のものが存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "gakutika_id で他人の学チカを指定しているとき" do
        let!(:user) do
          FactoryBot.create(:user)
        end
        let!(:user2) do
          User.create(password: 'passssss', email: 'ma@example.com', name: 'abc')
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end
        let!(:gakutika) do
            user2.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        it 'status bad request を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: "企業A", gakutika_title: gakutika.title }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['不正な入力です'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "user_and_company が既に存在しているとき" do
        let!(:user) do
          FactoryBot.create(:user)
        end
        let!(:company) do
            FactoryBot.create(:company)
        end
        let!(:user_and_company) do
          UserAndCompany.create(user_id: user.id, company_id: company.id)
        end
        let!(:token) do
            exp = Time.now.to_i + 4 * 60 
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end
        let!(:gakutika) do
            user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        
        it 'status created を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: company.name, gakutika_title: gakutika.title }}, headers: { "Authorization" => "JWT " + token }
          expect(UserAndCompany.count).to match(1)
          expect(response).to have_http_status(:created)
        end

      end

      context "user_and_company_and_gakutika が既に存在しているとき" do
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
        let!(:gakutika) do
          user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        let!(:user_and_company) do
          UserAndCompany.create(user_id: user.id, company_id: company.id)
        end
        let!(:user_and_company_and_gakutika) do
          user_and_company.user_and_company_and_gakutikas.create(gakutika_id: gakutika.id, user_and_company_id: user_and_company.id)
        end
        it 'もともとその企業でその学チカを話す予定です を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: company.name, gakutika_title: gakutika.title }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['もともとその企業でその学チカを話す予定です'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "gakutika_title が入力されていない時" do
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
        let!(:gakutika) do
          user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        let!(:user_and_company) do
          UserAndCompany.create(user_id: user.id, company_id: company.id)
        end
        it 'status bad request を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: company.name, gakutika_title: " " }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当のものが存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "gakutika_title が param に存在しない時" do
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
        let!(:gakutika) do
          user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        let!(:user_and_company) do
          UserAndCompany.create(user_id: user.id, company_id: company.id)
        end
        it 'status bad request を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: company.name}}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当のものが存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "company_name が入力されていない時" do
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
        let!(:gakutika) do
          user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        let!(:user_and_company) do
          UserAndCompany.create(user_id: user.id, company_id: company.id)
        end
        it 'status bad request を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {company_name: " ", gakutika_title: gakutika.title }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "company_name が param に存在しない時" do
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
        let!(:gakutika) do
          user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end
        let!(:user_and_company) do
          UserAndCompany.create(user_id: user.id, company_id: company.id)
        end
        it 'status bad request を返す' do
          post api_user_and_company_and_gakutikas_path, params: {user_and_company_and_gakutika: {gakutika_title: gakutika.title }}, headers: { "Authorization" => "JWT " + token }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

    end
  end
end
