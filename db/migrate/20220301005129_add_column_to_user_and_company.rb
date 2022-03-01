class AddColumnToUserAndCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :user_and_companies, :latest_interview_day, :Date
  end
end
