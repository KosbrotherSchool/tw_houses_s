class CreateRentHouses < ActiveRecord::Migration
  def change
    create_table :rent_houses do |t|
     
      t.string :title
      t.string :promote_pic_link
      t.string :link
     
      t.integer :price
      t.string :address
      t.string :deposit
      t.decimal :rent_area, :precision => 10, :scale => 2

      t.integer :layer
      t.integer :total_lyaers
      t.integer :building_age

      t.integer :rooms
      t.integer :living_rooms
      t.integer :rest_rooms
      t.integer :balconies

      t.string :parking_type

      t.decimal :x_long,  :precision => 15, :scale => 10
      t.decimal :y_lat, :precision => 15, :scale => 10

      t.integer :guard_price
      t.string :mint_rent_time
      t.boolean :is_cooking
      t.boolean :is_pet
      t.string :identity
      t.string :sexual_restriction
      t.string :orientation
      t.string :furniture
      t.string :equipment
      t.string :living_explanation
      t.string :communication
      t.text :feature_html

      t.string :verder_name
      t.string :phone_link
      t.string :phone_number

      t.integer :building_type_id
      t.integer :rent_type_id
      t.integer :county_id
      t.integer :town_id  

      t.boolean :is_show
      t.boolean :is_keep_show
      t.boolean :is_need_update

      t.integer :create_date_num

      t.timestamps
    end
  end
end
