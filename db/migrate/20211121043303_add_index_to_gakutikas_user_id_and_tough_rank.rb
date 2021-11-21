class AddIndexToGakutikasUserIdAndToughRank < ActiveRecord::Migration[6.0]
  def change
    add_index :gakutikas, [:user_id, :tough_rank], unique: true
  end
end
