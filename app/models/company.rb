class Company < ApplicationRecord
    has_many :questions, dependent: :destroy
    has_many :user_and_companies, dependent: :destroy
    validates :name, presence: true
end
