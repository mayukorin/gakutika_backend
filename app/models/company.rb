class Company < ApplicationRecord
    has_many :questions, dependent: :destroy
    has_many :user_and_companies, dependent: :destroy do
        def find_by_user(user_id)
            find_by(user_id: user_id)
        end
    end
    validates :name, presence: true
end
