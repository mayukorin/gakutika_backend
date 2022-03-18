require 'rails_helper'

RSpec.describe Gakutika, type: :model do
  context "タイトル，内容，開始年月，終了年月，順位がある場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "有効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).to be_valid
    end
  end

  context "タイトルがnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: nil, content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      # expect(gakutika.errors[:title]).to match(["タイトルを入力してください"])
      expect(gakutika.errors.full_messages).to match(["タイトルを入力してください"])
    end
  end

  context "タイトルがない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["タイトルを入力してください"])
    end
  end

  context "タイトルが空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["タイトルを入力してください"])
    end
  end

  context "内容がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: nil, tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["内容を入力してください"])
    end
  end

  context "内容がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["内容を入力してください"])
    end
  end

  context "内容が空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["内容を入力してください"])
    end
  end

  context "開始年月がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: nil, end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["開始年月を入力してください"])
    end
  end

  context "開始年月がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["開始年月を入力してください"])
    end
  end

  context "終了年月がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: nil)
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["終了年月を入力してください"])
    end
  end

  context "終了年月がない場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["終了年月を入力してください"])
    end
  end

  context "順位がnilの場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: nil, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["頑張り順は数値で入力してください"])
    end
  end

  context "順位が空白の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: "", start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["頑張り順は数値で入力してください"])
    end
  end

  context "順位が0の場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika = user.gakutikas.build(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 0, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika).not_to be_valid
      expect(gakutika.errors.full_messages).to match(["頑張り順は0より大きい値にしてください"])
    end
  end

  context "順位がかぶっている場合" do
    let!(:user) do
      FactoryBot.create(:user)
    end

    it "無効" do
      gakutika1 = user.gakutikas.create(title: "aaaaaa", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      gakutika2 = user.gakutikas.build(title: "cccccc", content: "bbbbbbbbbbbbbb", tough_rank: 1, start_month: Date.new(2017,9,7), end_month: Date.new(2017,10,7))
      expect(gakutika2).not_to be_valid
      expect(gakutika2.errors.full_messages).to match(["頑張り順は既に存在します"])
    end
  end


end
