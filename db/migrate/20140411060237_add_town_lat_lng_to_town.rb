class AddTownLatLngToTown < ActiveRecord::Migration
  def change
    add_column :towns, :x_lng, :decimal,  :precision => 15, :scale => 10
    add_column :towns, :y_lat, :decimal,  :precision => 15, :scale => 10
  end
end
