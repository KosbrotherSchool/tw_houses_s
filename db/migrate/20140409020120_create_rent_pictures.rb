class CreateRentPictures < ActiveRecord::Migration
  def change
    create_table :rent_pictures do |t|
      t.integer :rent_id
      t.string :picture_link

      t.timestamps
    end
  end
end
