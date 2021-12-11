class CreateUserAndCompanyAndGakutikas < ActiveRecord::Migration[6.0]
  def change
    create_table :user_and_company_and_gakutikas do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.references :company, null: false, foreign_key: true, on_delete: :cascade
      t.references :gakutika, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
