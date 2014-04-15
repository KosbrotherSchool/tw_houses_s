class AddXyChangeColumnToRentHouse < ActiveRecord::Migration
  def change
    add_column :rent_houses, :xy_change, :decimal, :precision => 15, :scale => 10
  end
end
