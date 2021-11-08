require 'rails_helper'

RSpec.describe "TokenProvider", type: :model do
    describe "#call" do
        context "user_id をpayloadに指定した場合" do
            let!(:user) do
                FactoryBot.create(:user)
            end
            it "戻り値はnilでない" do
                token = TokenProvider.new.call(user_id: user.id)
                expect(token).not_to be_nil
            end
        end
        context "user_id をpayloadに指定しない場合" do
            let!(:user) do
                FactoryBot.create(:user)
            end
            it "戻り値はnilでない" do
                token = TokenProvider.new.call(user_not_id: user.id)
                expect(token).not_to be_nil
            end
        end
    end
end