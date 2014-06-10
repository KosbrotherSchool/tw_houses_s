class ChangePhoneNumberFormatInHouse < ActiveRecord::Migration
  def change
  	change_column :houses, :phone_number, :string
  end
end
