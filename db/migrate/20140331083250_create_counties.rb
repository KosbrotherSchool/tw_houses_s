class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name

      t.integer :county_web_id
      t.integer :county_house_num
      t.integer :current_house_page_num

      t.integer :county_rent_num
      t.integer :current_rent_page_num

      t.timestamps
    end
  end
end
