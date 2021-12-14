class AddUserAndCompanyToUserAndCompanyAndGakutika < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_and_company_and_gakutikas, :user_and_company, foreign_key: true, on_delete: :cascade
  end
end
