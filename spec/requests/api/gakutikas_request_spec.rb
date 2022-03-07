require 'rails_helper'

RSpec.describe "Api::Gakutikas", type: :request do
    '
    around(:each) do |example| 
        show_detailed_exceptions = Rails.application.env_config["action_dispatch.show_detailed_exceptions"]
        show_exceptions          = Rails.application.env_config["action_dispatch.show_exceptions"]

        Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false
        Rails.application.env_config["action_dispatch.show_exceptions"]          = true

        example.run

        Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = show_detailed_exceptions
        Rails.application.env_config["action_dispatch.show_exceptions"]          = show_exceptions

    end
    '
    describe "Gakutikas" do
        describe "#index" do
            context "ユーザの学チカ一覧を取得する場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + (4 * 60)
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end

                it 'status ok と gakutika 一覧を返す' do
                    gakutika1 = user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                    gakutika2 = user.gakutikas.create(title: "cccccc", content: "bbbbbbbbbbbbbb", tough_rank: 2, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                    get api_gakutikas_path, headers: { "Authorization" => "JWT " + token }
                    puts JSON.parse(response.body)
                    expect(response).to have_http_status(:ok)
                end
            end
        end

        describe "#create" do
            context "通常の学チカを登録する場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + (4 * 60)
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end

                it 'status created と 作成した学チカを返す' do
                    post api_gakutikas_path, headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル", content: "内容です", start_month: "2018-11", end_month: "2018-12", tough_rank: "0"} }
                    expect(response).to have_http_status(:created)
                    user_gakutika_cnt = user.gakutikas.count
                    expect(user_gakutika_cnt).to match(1)
                    # puts JSON.parse(response.body)
                    # puts "-----------"
                    new_gakutika = user.gakutikas.first
                    expected_response = { 'content' => '内容です', 'endMonth' => '2018-12', 'id' => new_gakutika.id, 'startMonth' => '2018-11', 'title' => 'タイトル', 'toughRank' => user_gakutika_cnt }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end
            end

            context "start month が入力されていない場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + (4 * 60)
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end

                it 'status bad request と 不正な入力です メッセージを返す' do
                    post api_gakutikas_path, headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル", content: "内容です", start_month: " ", end_month: "2018-12", tough_rank: "0"} }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['開始年月を入力してください'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end
            end

            context "start month が params に存在しない場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + (4 * 60)
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end

                it 'status bad request と 不正な入力です メッセージを返す' do
                    post api_gakutikas_path, headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル", content: "内容です",  end_month: "2018-12", tough_rank: "0"} }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['開始年月を入力してください'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end
            end

            context "tough rank が params に存在しない場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + (4 * 60)
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end

                it 'status bad request と 「不正な入力です」 メッセージを返す' do
                    post api_gakutikas_path, headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル", content: "内容です",  start_month: "2018-05", end_month: "2018-12"} }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['頑張り順は数値で入力してください'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end
            end

            context "title が重複している場合" do
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

                it 'status bad request と 「不正な入力です」 メッセージを返す' do
                    post api_gakutikas_path, headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "aaaaaa", content: "内容です",  start_month: "2018-05", end_month: "2018-12", tough_rank: "0"} }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['このタイトルの学チカは既に存在します．違うタイトルを入力してください'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

        end

        describe "#show" do
            context "リクエストされたidが存在する場合" do
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
                    exp = Time.now.to_i + (4 * 60) 
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end
                let!(:gakutika) do
                    user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                end
                let(:user_and_company_and_gakutika) do
                    UserAndCompanyAndGakutika.create(gakutika_id: gakutika.id, user_and_company_id: user_and_company.id)
                end

                it 'status ok と該当の学チカを返す' do
                    get api_gakutika_path(id: gakutika.id), headers: { "Authorization" => "JWT " + token }
                    expect(response).to have_http_status(:ok)
                    expected_response = { 'content' => 'bbbbbbbbbbbbbb', 'endMonth' => '2017-10', 'id' => gakutika.id, 'startMonth' => '2017-09', 'title' => 'aaaaaa', 'toughRank' => 1, 'user_and_companies' => []}
                    expect(JSON.parse(response.body)).to match(expected_response)
                end
            end

            context "リクエストされたidが存在しない場合" do
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

                it 'status bad request と「該当する学チカが存在しません」を返す' do
                    get api_gakutika_path(id: gakutika.id+1), headers: { "Authorization" => "JWT " + token }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['該当する学チカが存在しません'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end
            end

            '
            context "idがパラメータに含まれていない場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + 4 * 60
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end
                let!(:gakutika) do
                    user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1)
                end
                it "status bad request と「該当ページが存在しません」を返す" do
                    get api_gakutika_path
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { "message" => ["該当ページが存在しません"] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                    
                end
            end
            '

        end

        describe "#update" do
            context "updateしたい学チカが存在して，param も正しい場合" do
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

                it "status accepted と更新した学チカの情報を返す" do
                    patch api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル", content: "内容です", start_month: "2018-09", end_month: "2018-12", tough_rank: "1"} }
                    expect(response).to have_http_status(:accepted)
                    expected_response = { 'content' => '内容です', 'endMonth' => '2018-12', 'id' => gakutika.id, 'startMonth' => '2018-09', 'title' => 'タイトル', 'toughRank' => 1,  }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

            context "updateしたい学チカが存在して，start month が params に存在しない場合" do
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

                it "status accpeted を返す" do
                    patch api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル",  content: "bbbbbbbbbbbbbb", end_month: "2018-12", tough_rank: "1"} }
                    expect(response).to have_http_status(:accepted)
                    expected_response = { 'content' => 'bbbbbbbbbbbbbb', 'endMonth' => '2018-12', 'id' => gakutika.id, 'startMonth' => '2017-09', 'title' => 'タイトル', 'toughRank' => 1 }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

            context "updateしたい学チカが存在して，start month が入力されていない場合" do
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

                it "status accpeted を返す" do
                    patch api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル",  content: "bbbbbbbbbbbbbb", start_month: "", end_month: "2018-12", tough_rank: "1"} }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['開始年月を入力してください'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

            context "updateしたい学チカが存在して，tough rank が params に存在しない場合" do
                let!(:user) do
                    FactoryBot.create(:user)
                end
                let!(:token) do
                    exp = Time.now.to_i + (4 * 60)
                    TokenProvider.new.call(user_id: user.id, exp: exp)
                end
                let!(:gakutika) do
                    user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 2, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                end

                it "status accpeted を返す" do
                    patch api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル",  content: "bbbbbbbbbbbbbb", start_month: "2018-09",  end_month: "2018-12"} }
                    expect(response).to have_http_status(:accepted)
                    expected_response = { 'content' => 'bbbbbbbbbbbbbb', 'endMonth' => '2018-12', 'id' => gakutika.id, 'startMonth' => '2018-09', 'title' => 'タイトル', 'toughRank' => 2 }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

            context "updateしたい学チカが存在して，param に不要なものが入っている場合" do
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

                it "status bad request と 不正な入力です メッセージを返す" do
                    patch api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル",  content: "bbbbbbbbbbbbbb", add_field: "aaaa", start_month: "2018-09", end_month: "2018-12", tough_rank: "1"} }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['不正な入力です'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

            context "updateしたい学チカが存在して，param に gakutika が含まれていない場合" do
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

                it "status bad request と 不正な入力です メッセージを返す" do
                    patch api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }, params: { title: "タイトル",  content: "bbbbbbbbbbbbbb", add_field: "aaaa", start_month: "2018-09", end_month: "2018-12", tough_rank: "1" }
                    expect(response).to have_http_status(:bad_request)
                    expected_response = { 'message' => ['不正な入力です'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

            context "updateしたい学チカが存在しない場合" do
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

                it "status bad request と 該当する学チカが存在しません メッセージを返す" do
                    patch api_gakutika_path(gakutika.id+10), headers: { "Authorization" => "JWT " + token }, params: { gakutika: { title: "タイトル",  content: "bbbbbbbbbbbbbb", start_month: "2018-09", end_month: "2018-12", tough_rank: "1" } }
                    expected_response = { 'message' => ['該当する学チカが存在しません'] }
                    expect(JSON.parse(response.body)).to match(expected_response)
                end

            end

        end
    end

    describe "#updateToughRank" do
        context "通常" do
            let!(:user) do
                FactoryBot.create(:user)
            end
            let!(:token) do
                exp = Time.now.to_i + (4 * 60)
                TokenProvider.new.call(user_id: user.id, exp: exp)
            end

            it 'status ok と gakutika 一覧を返す' do
                gakutika1 = user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: "1", start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                gakutika2 = user.gakutikas.create(title: "cccccc", content: "bbbbbbbbbbbbbb", tough_rank: "2", start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
                g1_id = gakutika1.id
                g2_id = gakutika2.id
                post api_update_tough_rank_path, headers: { "Authorization" => "JWT " + token }, params: { id_and_new_tough_rank: { "#{g1_id}": "2", "#{g2_id}": "1" } }
                expect(response).to have_http_status(:ok)
                expect(gakutika1.reload.tough_rank).to match(2)
                expect(gakutika2.reload.tough_rank).to match(1)
            end
        end

    end

    describe "#destroy" do
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

            it 'status no_content を返す' do
                delete api_gakutika_path(gakutika.id), headers: { "Authorization" => "JWT " + token }
                expect(response).to have_http_status(:no_content)
                expect(Gakutika.count).to match(0)
            end
        end

        context "削除したい学チカが存在しない場合" do
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

            it 'status bad request と 該当する学チカが存在しません メッセージを返す' do
                delete api_gakutika_path(gakutika.id+10), headers: { "Authorization" => "JWT " + token }
                expect(response).to have_http_status(:bad_request)
                expected_response = { 'message' => ['該当する学チカが存在しません'] }
                expect(JSON.parse(response.body)).to match(expected_response)
            end
        end
    end

    describe "#search" do
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
                get api_path("aaaa"), headers: { "Authorization" => "JWT " + token }
                expect(response).to have_http_status(:ok)
                puts JSON.parse(response.body)
            end

        end
    end
end
