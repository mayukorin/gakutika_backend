class AddColumnToGakutikas < ActiveRecord::Migration[6.0]
  def change
    add_column :gakutikas, :start_month, :Date
    add_column :gakutikas, :end_month, :Date
  end
end
