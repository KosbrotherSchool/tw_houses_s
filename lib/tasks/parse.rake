# encoding: utf-8
require "rubygems"
require "nokogiri"

namespace :parse do 

	task :parse_all_raw_list => :environment do
		House.update_all("is_keep_show = false")
		House.update_all("is_need_update = true")
		all_raw_list = RawList.all
		all_raw_list.each do |raw_list|
			ParseListWorker.perform_async(raw_list.id)
		end
	end

	task :parse_all_rent_raw_list => :environment do
		RentHouse.update_all("is_keep_show = false")
		RentHouse.update_all("is_need_update = true")
		all_raw_list = RawRentList.all
		all_raw_list.each do |raw_list|
			ParseRentListWorker.perform_async(raw_list.id)
		end
	end

end
