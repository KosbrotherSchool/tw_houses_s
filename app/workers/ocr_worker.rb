#encoding: utf-8
require 'tesseract'

class OcrWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(house_id)

  	house = RentHouse.find(house_id)

  	begin
  		img = MiniMagick::Image.open("phone_pics/image#{house.id}.jpeg")
		img.crop("#{img[:width] - 2}x#{img[:height] - 2}+1+1") #去掉边框（上下左右各1像素）  
		img.colorspace("GRAY") #灰度化  
		img.monochrome #二值化  

		e = Tesseract::Engine.new {|e|
		  e.language  = :eng
		  e.whitelist = '0123456789'
		}
		phone_s = e.text_for(img).strip.gsub(" ","")
		puts phone_s
		house.phone_number = phone_s
		house.save
  	rescue Exception => e
  		puts "error"
  		# re_download
  		DownloadImageWorker.perform_async(house.id)
  	end

  end
end