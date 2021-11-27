class AddToughRankToGakutika < ActiveRecord::Migration[6.0]
  def change
    add_column :gakutikas, :tough_rank, :integer
  end
end
