class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :value
      t.references :image
      t.references :user

      t.timestamps null: false
    end
  end
end
