class CreateTvdbobjs < ActiveRecord::Migration
  def change
    create_table :tvdbobjs do |t|
      t.string :name
      t.integer :series_id
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end
end
