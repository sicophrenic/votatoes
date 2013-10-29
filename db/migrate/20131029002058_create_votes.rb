class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :votato_id, :null => false
      t.string :vote_type, :null => false

      t.timestamps
    end
    add_index :votes, [:user_id, :votato_id], :unique => true
  end

  def self.down
    drop_table :votes
  end
end
