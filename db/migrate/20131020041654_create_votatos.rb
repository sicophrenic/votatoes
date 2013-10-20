class CreateVotatos < ActiveRecord::Migration
  def change
    create_table :votatos do |t|
      t.integer :plantation_id, :null => false
      t.integer :total, :default => 0
      t.string :series_id, :null => false

      t.timestamps
    end
  end
end
