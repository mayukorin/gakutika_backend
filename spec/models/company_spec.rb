require 'rails_helper'

RSpec.describe Company, type: :model do
  context "name が正しくある場合" do
    it "有効" do
      company = Company.new(name: "A株式会社")
      expect(company).to be_valid
    end
  end
  context "name がnilの場合" do
    it "無効" do
      company = Company.new(name: nil)
      expect(company).not_to be_valid
      expect(company.errors.full_messages).to match(["企業名を入力してください"])
    end
  end
  context "name がない場合" do
    it "有効" do
      company = Company.new()
      expect(company).not_to be_valid
      expect(company.errors.full_messages).to match(["企業名を入力してください"])
    end
  end
  context "name が空白の場合" do
    it "有効" do
      company = Company.new(name: " ")
      expect(company).not_to be_valid
      expect(company.errors.full_messages).to match(["企業名を入力してください"])
    end
  end
end
