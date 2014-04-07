class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      
      t.string :title
      t.string :promote_pic_link
      t.string :link

      t.integer :price
      t.string :address
      t.decimal :square_price, :precision => 10, :scale => 2
      t.decimal :total_area, :precision => 10, :scale => 2
      
      t.integer :layer
      t.integer :total_lyaers
      t.integer :building_age

      t.integer :rooms
      t.integer :living_rooms
      t.integer :rest_rooms
      t.integer :balconies

      t.decimal :parking_area, :precision => 10, :scale => 2
      t.string :parking_type

      t.decimal :x_long,  :precision => 15, :scale => 10
      t.decimal :y_lat, :precision => 15, :scale => 10

      t.integer :guard_price
      t.string :orientation
      t.boolean :is_renting
      t.string :ground_explanation
      t.string :living_explanation
      t.text :feature_html

      t.string :verder_name
      t.string :phone_link
      t.integer :phone_number

      t.integer :building_type_id
      t.integer :ground_type_id
      t.integer :county_id
      t.integer :town_id    
      t.timestamps
    end
  end
end
