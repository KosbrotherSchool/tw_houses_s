# encoding: utf-8

namespace :ocr do

	# task :test_ocr => :environment do
	# 	begin
	# 		img = MiniMagick::Image.open("phone_pics/image7.jpeg")
	# 		img.crop("#{img[:width] - 2}x#{img[:height] - 2}+1+1") #去掉边框（上下左右各1像素）  
	# 		img.colorspace("GRAY") #灰度化  
	# 		img.monochrome #二值化  

	# 		e = Tesseract::Engine.new {|e|
	# 		  e.language  = :eng
	# 		  e.whitelist = '0123456789'
	# 		}
	# 		phone_s = e.text_for(img).strip.gsub(" ","")

	# 		puts phone_s
	# 	rescue Exception => e
	# 		puts "need rescue"
	# 	end
		
	# end

	# task :download_img => :environment do

	# 	url = "http://statics.591.com.tw/tools/showPhone.php?phone=rOZTZugU%2Fe5hHOKui2nS%2BRxZOK8&type=rbJWMO5B%2BL5g"

	# 	downloaded_file = File.open("image1.jpeg",'wb')
		
	# 	request = Typhoeus::Request.new(
	# 		url		
	# 	)

	# 	request.on_body do |chunk|
	# 	  downloaded_file.write(chunk)
	# 	end

	# 	request.run
	# end

	task :download_all_rent_imgs => :environment do

		houses = RentHouse.where("phone_link is not null and is_keep_show = true")
		houses.each do |house|
			DownloadImageWorker.perform_async(house.id)
		end

	end

	task :ocr_all_rent_imgs => :environment do

		houses = RentHouse.where("phone_link is not null and is_keep_show = true")
		houses.each do |house|
			OcrWorker.perform_async(house.id)
		end
		
	end

	task :download_all_house_imgs => :environment do

		houses = House.where("phone_link is not null and is_keep_show = true")
		houses.each do |house|
			DownloadHouseImageWorker.perform_async(house.id)
		end

	end

	task :ocr_all_house_imgs => :environment do

		houses = House.where("phone_link is not null and is_keep_show = true")
		houses.each do |house|
			OcrHouseWorker.perform_async(house.id)
		end
		
	end



	# task :test_proxy => :environment do

	# 	url = "http://statics.591.com.tw/tools/showPhone.php?phone=rOZTZugU%2Fe5hHOKui2nS%2BRxZOK8&type=rbJWMO5B%2BL5g"

	# 	downloaded_file = File.open("image00000.jpeg",'wb')
		
	# 	proxy = Proxy.find(:first, :order => "RAND()")
	#     proxy_addr = proxy.proxy_addr
	#     proxy_port = proxy.proxy_port.to_s

	# 	request = Typhoeus::Request.new(
	# 		url,
	# 		:proxy => proxy_addr+":"+proxy_port	
	# 	)

	# 	request.on_body do |chunk|
	# 	  downloaded_file.write(chunk)
	# 	end

	# 	request.run

	# 	if request.response.code != 200
	# 		puts request.response.code
	# 		proxy.delete
	# 	else
	# 		puts "OK"
	# 	end

	# end

end 