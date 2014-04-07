class AddCountyNumsToCounty < ActiveRecord::Migration
  def change
    add_column :counties, :county_nums, :integer
  end
end
