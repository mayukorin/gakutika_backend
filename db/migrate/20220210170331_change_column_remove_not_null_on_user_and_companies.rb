class ChangeColumnRemoveNotNullOnUserAndCompanies < ActiveRecord::Migration[6.0]
  def change
    change_column_null :user_and_companies, :company_id, true
  end
end
