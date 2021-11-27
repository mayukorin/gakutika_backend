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
    end
  end

end
