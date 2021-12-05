require 'rails_helper'

RSpec.describe Question, type: :model do
  context "質問内容，解答，学チカ，企業，質問日がある場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "有効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).to be_valid
    end
  end
  context "質問内容がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: nil, answer: "bbbbbbbbbbbbbb", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["質問内容を入力してください"])
    end
  end
  context "質問内容が空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: " ", answer: "bbbbbbbbbbbbbb", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["質問内容を入力してください"])
    end
  end
  context "質問内容がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(answer: "bbbbbbbbbbbbbb", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["質問内容を入力してください"])
    end
  end
  context "解答がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: nil, company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["解答を入力してください"])
    end
  end
  context "解答が空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: " ", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["解答を入力してください"])
    end
  end
  context "解答がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["解答を入力してください"])
    end
  end
  context "company_id がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: nil, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["企業を入力してください"])
    end
  end
  context "company_id が空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: " ", day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["企業を入力してください"])
    end
  end
  context "company_id がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["企業を入力してください"])
    end
  end
  context "company_id と一致する company が存在しない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id+10, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["企業を入力してください"])
    end
  end
  context "day が nil の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, day: nil)
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["日付けを入力してください"])
    end
  end
  context "day が 空白 の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, day: " ")
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["日付けを入力してください"])
    end
  end
  context "day が ない 場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = gakutika.questions.build(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id)
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["日付けを入力してください"])
    end
  end
  context "gakutika_id が nil の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = Question.new(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, gakutika_id: nil, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["学チカを入力してください"])
    end
  end
  context "gakutika_id が 空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = Question.new(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, gakutika_id: " ", day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["学チカを入力してください"])
    end
  end
  context "gakutika_id がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = Question.new(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["学チカを入力してください"])
    end
  end
  context "gakutika_id に一致する gakutikaがない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end
    let!(:gakutika) do
      user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
    end
    let!(:company) do
      FactoryBot.create(:company)
    end
    it "無効" do
      question = Question.new(query: "aaaaaa", answer: "bbbbbbbbbbbbbb", company_id: company.id, gakutika_id: gakutika.id+10, day: Date.new(2017,10,7))
      expect(question).not_to be_valid
      expect(question.errors.full_messages).to match(["学チカを入力してください"])
    end
  end
end
