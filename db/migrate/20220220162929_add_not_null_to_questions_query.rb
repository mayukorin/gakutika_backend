class AddNotNullToQuestionsQuery < ActiveRecord::Migration[6.0]
  def change
    change_column :questions, :query, :string, null: false
    change_column :questions, :answer, :string, null: false
    change_column :questions, :day, :Date, null: false
  end
end
