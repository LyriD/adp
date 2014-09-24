class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :content
      t.string :alt
      t.integer :page_id

      t.timestamps
    end
  end
end
