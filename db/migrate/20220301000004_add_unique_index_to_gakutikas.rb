class AddUniqueIndexToGakutikas < ActiveRecord::Migration[6.0]
  def change
    add_index :gakutikas, [:title, :user_id], unique: true
  end
end
