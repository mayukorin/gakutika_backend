require 'rails_helper'

RSpec.describe User, type: :model do

    context "email，name, password が正しくある場合" do
        it "有効" do
          user = User.new(email: "test@example.com", name: "abcabc", password: "password" )
          expect(user).to be_valid
        end
    end

    context "nameがnilの場合" do
        it "無効" do
            user = User.new(email: "test@example.com", name: nil, password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["名前を入力してください"])
        end
      end
    
    context "nameがない場合" do
        it "無効" do
            user = User.new(email: "test@example.com", password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["名前を入力してください"])
        end
    end
    
    context "nameが空白の場合" do
        it "無効" do
            user = User.new(email: "test@example.com", name: " ", password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["名前を入力してください"])
        end
    end

    context "nameが51文字以上の場合" do
        it "無効" do
            long_name = "a" * 51
            user = User.new(email: "test@example.com", name: long_name, password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["名前は50文字以内で入力してください"])
        end
    end

    context "emailがnilの場合" do
        it "無効" do
            user = User.new(email: nil, name: "abcabc", password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["メールアドレスを入力してください", "メールアドレスは正しい形式で入力してください"])
        end
      end
    
    context "emailがない場合" do
        it "無効" do
            user = User.new(name: "abcabc",password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["メールアドレスを入力してください", "メールアドレスは正しい形式で入力してください"])
        end
    end
    
    context "emailが空白の場合" do
        it "無効" do
            user = User.new(email: " ", name: "abcabc", password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["メールアドレスを入力してください", "メールアドレスは正しい形式で入力してください"])
        end
    end

    context "emailが256文字以上の場合" do
        it "無効" do
            long_email = "a" * 255 + "@example.com"
            user = User.new(name: "abcabc", email: long_email, password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["メールアドレスは255文字以内で入力してください"])
        end
    end

    context "emailが正しい形式でない場合" do
        it "無効" do
            
            user = User.new(name: "abcabc", email: "abcabc", password: "password" )
            expect(user).not_to be_valid
            expect(user.errors.full_messages).to match(["メールアドレスは正しい形式で入力してください"])
        end
    end

    context "emailが既に存在する場合" do
        it "無効" do
            user1 = User.create(email: "test@example.com", name: "abcabc", password: "password" )
            user2 = User.new(email: "test@example.com", name: "abcabc", password: "password" )
            expect(user2).not_to be_valid
            expect(user2.errors.full_messages).to match(["メールアドレスは既に使われています"])
        end
    end
    
      
end
