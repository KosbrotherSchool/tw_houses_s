class AddCurrentPageNumToCounty < ActiveRecord::Migration
  def change
    add_column :counties, :current_page_num, :integer
  end
end
