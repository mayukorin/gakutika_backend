class ChangeColumnToQuestion < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :questions, :gakutikas
    remove_index :questions, :gakutika_id
    remove_reference :questions, :gakutika
    remove_foreign_key :questions, :companies
    remove_index :questions, :company_id
    remove_reference :questions, :company
  end
end
