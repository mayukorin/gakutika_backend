class CreateGakutikas < ActiveRecord::Migration[6.0]
  def change
    create_table :gakutikas do |t|
      t.string :title
      t.string :content
      t.references :user, foreign_key: true, on_delete: :cascade
      t.timestamps
    end
  end
end
