class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :query
      t.date :day
      t.string :answer
      t.references :company, foreign_key: true, on_delete: :cascade
      t.references :gakutika, foreign_key: true, on_delete: :cascade
      t.timestamps
    end
  end
end
