class AddIndexToCompaniesName < ActiveRecord::Migration[6.0]
  def change
    change_column :companies, :name, :string, null: false
    add_index :companies, :name, unique: true
  end
end
