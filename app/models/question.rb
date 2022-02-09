class Question < ApplicationRecord
    belongs_to :company
    belongs_to :gakutika
    has_one :user, through: :gakutika
    validates :query, presence: true
    validates :answer, presence: true
    validates :day, presence: true
end
