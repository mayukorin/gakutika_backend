require 'rails_helper'

RSpec.describe "Api::Questions", type: :request do
  describe "Questions" do
    describe "#create" do
      context "通常のquestionを登録する場合" do
        let!(:user) do
          FactoryBot.create(:user)
        end
        let!(:token) do
            exp = Time.now.to_i + (4 * 60) 
            TokenProvider.new.call(user_id: user.id, exp: exp)
        end
        let!(:c) do
          Company.create(name: "あいう")
        end
        let!(:gakutika) do
            user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
        end

        it 'status created と作成した質問を返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          puts JSON.parse(response.body)
          expect(response).to have_http_status(:created)
          new_question = Question.find_by(query: '質問内容')
          expected_response = { 'id' => new_question.id, 'query' => '質問内容', 'answer' => '解答', 'companyName' => 'あいう', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
          user_and_company_cnt = UserAndCompany.where(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.company.id).count
          expect(user_and_company_cnt).to match(1)
          user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.company.id)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(user_and_company: user_and_company.id, gakutika: new_question.user_and_company_and_gakutika.gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(1)
          company_cnt = Company.all.count()
          expect(company_cnt).to match(1)
        end
      end

      context "company_name が params に存在しない場合" do
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

        it 'status bad request と 企業名を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答",  day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
        end
      end

      context "company_name が 入力されていない場合" do
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

        it 'status bad request と 企業名を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答",  company_name: " ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
        end
      end

      context "query が params に存在しない場合" do
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

        it 'status bad request と 質問内容を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['質問内容を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "query が 入力されていない場合" do
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

        it 'status bad request と 質問内容を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: " ", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['質問内容を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "answer が params に存在しない場合" do
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

        it 'status bad request と 解答を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['解答を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "answer が 入力されていない場合" do
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

        it 'status bad request と 解答を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: " ", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['解答を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "day が params に存在しない場合" do
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

        it 'status bad request と日付けを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう",gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['日付けを入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "day が 入力されていない場合" do
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

        it 'status bad request と 日付けを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['日付けを入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "gakutika_id が params に存在しない場合" do
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

        it 'status bad request と 学チカを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04" } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当する学チカが存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "gakutika_id が 入力されていない場合" do
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

        it 'status bad request と 学チカを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: "" } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当する学チカが存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

      context "gakutika_id と一致する gakutika が存在しない場合" do
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

        it 'status bad request と 学チカを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: (gakutika.id+1).to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当する学チカが存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_company_cnt = Company.all.count
          expect(new_company_cnt).to match(0)
          new_user_and_company_cnt = UserAndCompany.all.count
          expect(new_user_and_company_cnt).to match(0)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.all.count
          expect(new_user_and_company_and_gakutika_cnt).to match(0)
        end
      end

    end

    describe "#update" do
      context "通常のquestionを更新する(companyは同じ)場合" do
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
        let(:user_and_company_and_gakutika) do
          UserAndCompanyAndGakutika.create(gakutika_id: gakutika.id, user_and_company_id: user_and_company.id)
        end
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status accepted と更新した質問を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答2', 'companyName' => 'あいう', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_question = Question.find_by(query: '質問内容2')
          user_and_company_cnt = UserAndCompany.where(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.user_and_company.company.id).count
          expect(user_and_company_cnt).to match(1)
          user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.user_and_company.company.id)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(user_and_company: user_and_company.id, gakutika: new_question.user_and_company_and_gakutika.gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(1)
        end
      end
      
      context "通常のquestionを更新する(companyは新しい)場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status accepted と更新した質問を返す' do
          # puts user_and_company_and_gakutika
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "ういあ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答2', 'companyName' => 'ういあ', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_question = Question.find_by(query: '質問内容2')
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(2)
          new_user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.user_and_company.company.id)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(user_and_company: new_user_and_company.id, gakutika: new_question.user_and_company_and_gakutika.gakutika.id).count
          expect(new_user_and_company_and_gakutika_cnt).to match(1)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(2)
        end
      end

      context "day が params に存在しない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status accepted と更新した質問を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "ういあ", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答2', 'companyName' => 'ういあ', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_question = Question.find_by(query: '質問内容2')
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(2)
          new_user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.user_and_company.company.id)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(user_and_company: new_user_and_company.id, gakutika: new_question.user_and_company_and_gakutika.gakutika.id).count
          expect(new_user_and_company_and_gakutika_cnt).to match(1)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(2)
        end
      end

      context "day が 入力されていない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status bad request と 日付けを入力してください メッセージを返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "ういあ", day: " ", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['日付けを入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(1)
          user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: question.user_and_company_and_gakutika.user_and_company.company.id)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(1)
        end
      end

      context "company_name が params に存在しない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status accepted と更新した質問を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答2', 'companyName' => 'あいう', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_question = Question.find_by(query: '質問内容2')
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(1)
          new_user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.user_and_company.company.id)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(user_and_company: new_user_and_company.id, gakutika: new_question.user_and_company_and_gakutika.gakutika.id).count
          expect(new_user_and_company_and_gakutika_cnt).to match(1)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(1)
        end
      end

      context "company_name が 入力されていない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status bad request と 企業名を入力してください メッセージを返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  company_name: " ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(1)
          user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: question.user_and_company_and_gakutika.user_and_company.company.id)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(1)
        end
      end

      context "updateしたいquestionが存在しない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it "status bad request と該当する質問が存在しません メッセージを返す" do
          patch api_question_path(question.id+1), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  company_name: "abc", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当する質問が存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(1)
          user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: question.user_and_company_and_gakutika.user_and_company.company.id)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(1)
        end

      end

      context "answer が param に存在しない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status accepted と更新した質問を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", company_name: "ういあ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答', 'companyName' => 'ういあ', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
          new_question = Question.find_by(query: '質問内容2')
          user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          expect(user_and_company_cnt).to match(2)
          new_user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: new_question.user_and_company_and_gakutika.user_and_company.company.id)
          new_user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(user_and_company: new_user_and_company.id, gakutika: new_question.user_and_company_and_gakutika.gakutika.id).count
          expect(new_user_and_company_and_gakutika_cnt).to match(1)
          user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          expect(user_and_company_and_gakutika_cnt).to match(2)
        end
      end

      context "gakutika_id が 入力されていない場合" do
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
        let!(:question) do
          Question.create(query: "質問内容", answer: "解答", user_and_company_and_gakutika_id: user_and_company_and_gakutika.id, day: Date.new(2021, 11, 4))
        end

        it 'status accepted を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  company_name: "ういあ", day: "2021-11-04", gakutika_id: "" } }
          expect(response).to have_http_status(:accepted)
          # expected_response = { 'message' => ['学チカを入力してください'] }
          # expect(JSON.parse(response.body)).to match(expected_response)
          # user_and_company_cnt = UserAndCompany.where(user_id: user.id).count
          # expect(user_and_company_cnt).to match(1)
          # user_and_company = UserAndCompany.find_by(user_id: user.id, company_id: question.company.id)
          # user_and_company_and_gakutika_cnt = UserAndCompanyAndGakutika.where(gakutika: gakutika.id).count
          # expect(user_and_company_and_gakutika_cnt).to match(1)
          
        end
      end


    end 
  end


end
