#-*- coding: utf-8 -*-#
class CreateTmdbobjs < ActiveRecord::Migration
  def change
    create_table :tmdbobjs do |t|
      t.string :name
      t.integer :tmdb_id
      t.text :description
      t.string :image_url
      t.string :imdb_id

      t.timestamps
    end
  end
end
