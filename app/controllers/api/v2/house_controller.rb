class Api::V2::HouseController < ApplicationController

	def get_sale_detail

		id = params[:house_id]
		house = House.find(id)
		house_pics = Picture.where("house_id = #{id}")

		detail_data = Array.new
		detail_data << house
		detail_data << house_pics

		render :json => detail_data

	end


	# http://localhost:3000/api/v2/house/get_houses_by_distance?km_dis=0.3&center_x=121.517315&center_y=25.047908
	def get_houses_by_distance

		is_show_rent = params[:is_show_rent].to_i
		is_show_sale = params[:is_show_sale].to_i

		km_dis = params[:km_dis].to_d
		center_x = params[:center_x].to_f
    	center_y = params[:center_y].to_f
		degree_dis = km_dis * 0.009009 

		rent_price_min = params[:rp_min]
		rent_price_max = params[:rp_max]

		house_price_min = params[:hp_min]
		house_price_max = params[:hp_max]		

		area_min = params[:area_min]
		area_max = params[:area_max]

		age_min = params[:age_min]
		age_max = params[:age_max]

		rent_type = params[:rent_type]
		ground_type = params[:ground_type]

		rentPriceString = ""
		if rent_price_min != nil
			rentPriceString = "and price >= #{rent_price_min} "
		end

		if rent_price_max != nil
			rentPriceString = rentPriceString + "and price < #{rent_price_max} "
		end

		housePriceString = ""
		if house_price_min != nil
			housePriceString = "and price >= #{house_price_min} "
		end

		if house_price_max != nil
			housePriceString = housePriceString + "and price < #{house_price_max} "
		end

		rentAreaString = ""
		if area_min != nil
			rentAreaString = "and rent_area >= #{area_min} "
		end

		if area_max != nil
			rentAreaString = rentAreaString + "and rent_area < #{area_max}"
		end

		houseAreaString = ""
		if area_min != nil
			houseAreaString = "and total_area >= #{area_min} "
		end

		if area_max != nil
			houseAreaString = houseAreaString + "and total_area < #{area_max}"
		end

		houseAgeString = ""
		if age_min != nil
			houseAgeString = "and building_age >= #{age_min}"
		end

		if age_max != nil
			houseAgeString = "and building_age < #{age_max}"
		end

		rentTypeString = ""
		if rent_type != nil
			if rent_type.index("0")
				# do nothing
			else
				if rent_type.index("a")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 1"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 1"
					end
				end

				if rent_type.index("b")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 2"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 2"
					end
				end

				if rent_type.index("c")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 3"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 3"
					end
				end

				if rent_type.index("d")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 4"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 4"
					end
				end

				if rent_type.index("e")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 5"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 5"
					end
				end

				if rent_type.index("f")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 6"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 6"
					end
				end

				if rent_type.index("g")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 7"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 7"
					end
				end

				if rent_type.index("h")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 8"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 8"
					end
				end

				if rent_type.index("i")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 9"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 9"
					end
				end

				if rent_type.index("j")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 10"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 10"
					end
				end

				if rent_type.index("k")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 11"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 11"
					end
				end

				if rent_type.index("l")
					if rentTypeString.length == 0
						rentTypeString = rentTypeString + " and ( rent_type_id = 12"
					else
						rentTypeString = rentTypeString + " or rent_type_id = 12"
					end
				end

				rentTypeString = rentTypeString + ")"
			end
		end

		groundTypeString = ""
		if ground_type != nil
			if ground_type.index("0")
				# do nothing
			else
				if ground_type.index("a")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 1"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 1"
					end
				end

				if ground_type.index("b")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 2"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 2"
					end
				end

				if ground_type.index("c")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 3"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 3"
					end
				end

				if ground_type.index("d")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 4"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 4"
					end
				end

				if ground_type.index("e")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 5"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 5"
					end
				end

				if ground_type.index("f")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 6"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 6"
					end
				end

				if ground_type.index("g")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 7"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 7"
					end
				end

				if ground_type.index("h")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 8"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 8"
					end
				end

				if ground_type.index("i")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 9"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 9"
					end
				end

				if ground_type.index("j")
					if groundTypeString.length == 0
						groundTypeString = groundTypeString + " and ( ground_type_id = 10"
					else
						groundTypeString = groundTypeString + " or ground_type_id = 10"
					end
				end

				groundTypeString = groundTypeString + ")"

			end
			
		end




		critera = "x_long IS NOT NULL and y_lat IS NOT NULL and is_show = true"
		border = "and x_long > #{center_x - degree_dis} and x_long < #{center_x + degree_dis} and y_lat > #{center_y - degree_dis} and y_lat < #{center_y + degree_dis}"

		house_data = Array.new
		if is_show_rent == 1
			rent_items = RentHouse.select("id, title, promote_pic_link,  price, address, rent_area, layer, total_lyaers, rooms, rest_rooms, x_long, y_lat, rent_type_id").where("#{critera} #{border} #{rentTypeString} #{rentPriceString} #{rentAreaString}")
		else
			rent_items = Array.new
		end
		
		if is_show_sale == 1
			house_items = House.select("id, title, promote_pic_link,  price, address, total_area, layer, total_lyaers, rooms, rest_rooms, x_long, y_lat, ground_type_id").where("#{critera} #{border} #{groundTypeString} #{houseAgeString} #{housePriceString} #{houseAreaString}")
		else
			house_items = Array.new
		end
		
		house_data << rent_items
		house_data << house_items

		render :json => house_data

	end

end
