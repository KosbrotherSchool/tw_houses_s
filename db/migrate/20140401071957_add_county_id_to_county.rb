class AddCountyIdToCounty < ActiveRecord::Migration
  def change
    add_column :counties, :county_web_id, :integer
  end
end
