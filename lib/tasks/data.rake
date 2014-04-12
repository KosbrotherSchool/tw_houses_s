# encoding: utf-8

namespace :data do

	task :load_town_data => :environment do

		File.open("#{Rails.root}/db/towns.yml", 'r') do |file|
			YAML::load(file).each do |record|
				# puts record.id
				# puts record.size()
				# puts record[1]
				# puts record[1]["id"]
				puts record[1]["name"]
				# puts record[1]["county_id"]

				town = Town.new
				town.name = record[1]["name"]
				town.county_id = record[1]["county_id"].to_i
				town.save

			end
		end

	end

	# dump
	task :dump_table => :environment do
	  	sql  = "SELECT * FROM %s"
	  	skip_tables = ["schema_info"]
	  	ActiveRecord::Base.establish_connection("development")
	  	tables=ENV['TABLES'].split(',')
	  	tables ||= (ActiveRecord::Base.connection.tables - skip_tables)

	  	puts tables

	  	tables.each do |table_name|
	    	i = "000"
	    	File.open("#{Rails.root}/test/fixtures/#{table_name}.yml", 'w') do |file|
	      		data = ActiveRecord::Base.connection.select_all(sql % table_name)
	      		file.write data.inject({}) { |hash, record|
	        		hash["#{table_name}_#{i.succ!}"] = record
	        		hash
	      		}.to_yaml
	    	end
	  	end
	end

	task :update_show => :environment do
		RentHouse.update_all("is_show = is_keep_show")
	end

end