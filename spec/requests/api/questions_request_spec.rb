require 'rails_helper'

RSpec.describe "Api::Questions", type: :request do
  describe "Questions" do
    describe "#create" do
      context "通常のquestionを登録する場合" do
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
        it 'status created と作成した質問を返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:created)
          gakutika_question_cnt = gakutika.questions.count
          expect(gakutika_question_cnt).to match(1)
          new_question = gakutika.questions.first
          expected_response = { 'id' => new_question.id, 'query' => '質問内容', 'answer' => '解答', 'companyName' => 'あいう', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "company_name が params に存在しない場合" do
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
        it 'status bad request と 企業名を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答",  day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "company_name が 入力されていない場合" do
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
        it 'status bad request と  企業名を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答",  company_name: " ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "query が params に存在しない場合" do
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
        it 'status bad request と 質問内容を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['質問内容を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "query が 入力されていない場合" do
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
        it 'status bad request と  質問内容を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: " ", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['質問内容を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "answer が params に存在しない場合" do
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
        it 'status bad request と 解答を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['解答を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "answer が 入力されていない場合" do
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
        it 'status bad request と 解答を入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: " ", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['解答を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "day が params に存在しない場合" do
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
        it 'status bad request と 不正な入力です メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう",gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['不正な入力です'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "day が 入力されていない場合" do
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
        it 'status bad request と  不正な入力です メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['不正な入力です'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "gakutika_id が params に存在しない場合" do
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
        it 'status bad request と 学チカを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04" } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['学チカを入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "gakutika_id が 入力されていない場合" do
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
        it 'status bad request と  学チカを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: "" } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['学チカを入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "gakutika_id と一致する gakutika が存在しない場合" do
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
        it 'status bad request と  学チカを入力してください メッセージを返す' do
          post api_questions_path, headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容", answer: "解答", company_name: "あいう", day: "2021-11-04", gakutika_id: (gakutika.id+1).to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['学チカを入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

    end

    describe "#update" do
      context "通常のquestionを更新する(companyは同じ)場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status accepted と更新した質問を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "あいう", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答2', 'companyName' => 'あいう', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end
      
      context "通常のquestionを更新する(companyは新しい)場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status accepted と更新した質問を返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "ういあ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:accepted)
          expected_response = { 'id' => question.id, 'query' => '質問内容2', 'answer' => '解答2', 'companyName' => 'ういあ', 'day' => '2021-11-04' }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "day が params に存在しない場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status bad request と 不正な入力です メッセージを返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "ういあ", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['不正な入力です'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "day が 入力されていない場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status bad request と 不正な入力です メッセージを返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2", company_name: "ういあ", day: " ", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['不正な入力です'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "company_name が params に存在しない場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status bad request と 企業名を入力してください メッセージを返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "company_name が 入力されていない場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it 'status bad request と 企業名を入力してください メッセージを返す' do
          patch api_question_path(question.id), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  company_name: " ", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['企業名を入力してください'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end
      end

      context "updateしたいquestionが存在しない場合" do
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
        let!(:question) do
          gakutika.questions.create(query: "質問内容", answer: "解答", company_id: company.id, day: Date.new(2021, 11, 4))
        end
        it "status bad request と該当する質問が存在しません メッセージを返す" do
          patch api_question_path(question.id+1), headers: { "Authorization" => "JWT " + token }, params: { question: { query: "質問内容2", answer: "解答2",  company_name: "abc", day: "2021-11-04", gakutika_id: gakutika.id.to_s } }
          expect(response).to have_http_status(:bad_request)
          expected_response = { 'message' => ['該当する質問が存在しません'] }
          expect(JSON.parse(response.body)).to match(expected_response)
        end

    end

    end 
  end


end
