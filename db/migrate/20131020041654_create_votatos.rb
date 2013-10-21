#-*- coding: utf-8 -*-#
class CreateVotatos < ActiveRecord::Migration
  def change
    create_table :votatos do |t|
      t.integer :plantation_id, :null => false
      t.integer :obj_id
      t.integer :total, :default => 0

      t.timestamps
    end
  end
end
