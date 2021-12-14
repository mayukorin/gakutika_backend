class DeleteUserIdFromUserAndCompanyAndGakutika < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_and_company_and_gakutikas, :user_id, :integer 
    remove_column :user_and_company_and_gakutikas, :company_id, :integer 
  end
end
