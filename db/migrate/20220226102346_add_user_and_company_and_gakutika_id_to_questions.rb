class AddUserAndCompanyAndGakutikaIdToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user_and_company_and_gakutika, foreign_key: true
    change_column_null :questions, :user_and_company_and_gakutika_id, true
  end
end
