class Gakutika < ApplicationRecord
    belongs_to :user
    has_many :questions
    validates :title, presence: true
    validates :content, presence: true
    validates :start_month, presence: true
    validates :end_month, presence: true
    validates :tough_rank, numericality: { only_integer: true, greater_than: 0 },
                            uniqueness: { scope: :user_id }
end
