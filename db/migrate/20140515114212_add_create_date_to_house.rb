class AddCreateDateToHouse < ActiveRecord::Migration
  def change
    add_column :houses, :create_date_num, :integer
  end
end
