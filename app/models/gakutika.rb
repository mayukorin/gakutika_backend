class Gakutika < ApplicationRecord
    belongs_to :user
    validates :title, presence: { message: "タイトルを入力してください" }
    validates :content, presence: { message: "内容を入力してください" }
    validates :start_month, presence: { message: "開始年月を入力してください" }
    validates :end_month, presence: { message: "終了年月を入力してください" }
    validates :tough_rank, numericality: { only_integer: true, greater_than: 0, message: "頑張り順を入力してください" },
                            uniqueness: { scope: :user_id, message: "頑張り順が重複しています" }
end
