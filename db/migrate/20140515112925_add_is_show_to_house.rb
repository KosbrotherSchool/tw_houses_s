class AddIsShowToHouse < ActiveRecord::Migration
  def change
    add_column :houses, :is_show, :boolean
    add_column :houses, :is_keep_show, :boolean
    add_column :houses, :is_need_update, :boolean
  end
end
