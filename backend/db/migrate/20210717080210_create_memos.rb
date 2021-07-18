class CreateMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :memos do |t|
      t.references :favorite, null: false, foreign_key: true
      t.string :time
      t.string :comment

      t.timestamps
    end
  end
end
