# encoding: utf-8

namespace :ocr do

	task :test_ocr => :environment do
		img = MiniMagick::Image.open("phone_pics/image1.jpeg")
		img.crop("#{img[:width] - 2}x#{img[:height] - 2}+1+1") #去掉边框（上下左右各1像素）  
		img.colorspace("GRAY") #灰度化  
		img.monochrome #二值化  

		e = Tesseract::Engine.new {|e|
		  e.language  = :eng
		  e.whitelist = '0123456789'
		}
		phone_s = e.text_for(img).strip.gsub(" ","")

		puts phone_s
	end

	task :download_img => :environment do

		url = "http://statics.591.com.tw/tools/showPhone.php?phone=rOZTZugU%2Fe5hHOKui2nS%2BRxZOK8&type=rbJWMO5B%2BL5g"

		downloaded_file = File.open("image1.jpeg",'wb')
		
		request = Typhoeus::Request.new(
			url		
		)

		request.on_body do |chunk|
		  downloaded_file.write(chunk)
		end

		request.run
	end

	task :download_all_imgs => :environment do

		houses = House.all
		houses.each do |house|
			DownloadImageWorker.perform_async(house.id)
		end

	end

	task :ocr_all_imgs => :environment do

		houses = House.all
		houses.each do |house|
			OcrWorker.perform_async(house.id)
		end
		
	end

end 