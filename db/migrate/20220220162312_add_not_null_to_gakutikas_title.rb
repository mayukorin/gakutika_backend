class AddNotNullToGakutikasTitle < ActiveRecord::Migration[6.0]
  def change
    change_column :gakutikas, :title, :string, null: false
    change_column :gakutikas, :content, :string, null: false
    change_column :gakutikas, :start_month, :Date, null: false
    change_column :gakutikas, :end_month, :Date, null: false
    # add_check_constraint :gakutikas, "tough_rank > 0", name: "tough_rank_check"
  end
end
