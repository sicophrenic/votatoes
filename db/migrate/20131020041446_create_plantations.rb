class CreatePlantations < ActiveRecord::Migration
  def change
    create_table :plantations do |t|
      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.string :media, :null => false
      t.string :privacy, :null => false

      t.timestamps
    end
  end
end
