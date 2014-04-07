#encoding: utf-8
require 'tesseract'

class OcrWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(house_id)
    house = House.find(house_id)
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
	house.phone_number = phone_s.to_i
	house.save
  end
end