class AddIndexToUserAndCompaniesUserIdAndCompanyId < ActiveRecord::Migration[6.0]
  def change
    add_index :user_and_companies, [:user_id, :company_id], unique: true
  end
end
