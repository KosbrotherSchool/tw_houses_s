class Api::V1::HouseController < ApplicationController

	def get_rents_by_ids
		
		#  http://localhost:3000/api/v1/house/get_rents_by_ids?house_ids=2,3

		ids = params[:house_ids]
		ids_array = ids.split(",").map { |s| s.to_i }
		items = RentHouse.where(:id => ids_array)
		render :json => items
	
	end


	def get_rent_detail

		# http://localhost:3000/api/v1/house/get_rent_detail?house_id=2

		id = params[:house_id]
		house = RentHouse.find(id)
		rent_pics = RentPicture.where("rent_id = #{id}")

		detail_data = Array.new
		detail_data << house
		detail_data << rent_pics

		render :json => detail_data

	end


	def get_rents_by_distance

		# http://localhost:3000/api/v1/house/get_rents_by_distance?km_dis=0.3&center_x=121.4588&center_y=25.05535
		# http://106.186.31.71/api/v1/house/get_rents_by_distance?km_dis=0.3&center_x=121.4588&center_y=25.05535

		km_dis = params[:km_dis].to_d
		center_x = params[:center_x].to_f
    	center_y = params[:center_y].to_f
		degree_dis = km_dis * 0.009009 

		rent_price_min = params[:rp_min]
		rent_price_max = params[:rp_max]

		area_min = params[:a_min]
		area_max = params[:a_max]

		rent_type = params[:rent_type]
		building_type = params[:building_type]

		priceString = ""
		if rent_price_min != nil
			priceString = "and price >= #{rent_price_min} "
		end

		if rent_price_max != nil
			priceString = priceString + "and price < #{rent_price_max} "
		end

		areaString = ""
		if area_min != nil
			areaString = "and rent_area >= #{area_min} "
		end

		if area_max != nil
			areaString = areaString + "and rent_area < #{area_max}"
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


		buildingTypeString = ""
		if building_type != nil

			if building_type.index("0")
				# do nothing
			else

				if building_type.index("a")
					if buildingTypeString.length == 0
						buildingTypeString = buildingTypeString + " and ( building_type_id = 1"
					else
						buildingTypeString = buildingTypeString + " or building_type_id = 1"
					end
				end

				if building_type.index("b")
					if buildingTypeString.length == 0
						buildingTypeString = buildingTypeString + " and ( building_type_id = 2"
					else
						buildingTypeString = buildingTypeString + " or building_type_id = 2"
					end
				end

				if building_type.index("c")
					if buildingTypeString.length == 0
						buildingTypeString = buildingTypeString + " and ( building_type_id = 3"
					else
						buildingTypeString = buildingTypeString + " or building_type_id = 3"
					end
				end

				if building_type.index("d")
					if buildingTypeString.length == 0
						buildingTypeString = buildingTypeString + " and ( building_type_id = 4"
					else
						buildingTypeString = buildingTypeString + " or building_type_id = 4"
					end
				end

				buildingTypeString = buildingTypeString + ")"
			end
		end

		critera = "x_long IS NOT NULL and y_lat IS NOT NULL and is_show = true"
		border = "and x_long > #{center_x - degree_dis} and x_long < #{center_x + degree_dis} and y_lat > #{center_y - degree_dis} and y_lat < #{center_y + degree_dis}" 
		items = RentHouse.select("id, title, promote_pic_link,  price, address, rent_area, layer, total_lyaers, rooms, rest_rooms, x_long, y_lat, rent_type_id").where("#{critera} #{border}  #{rentTypeString} #{buildingTypeString} #{priceString} #{areaString}")

		render :json => items
	end

	def get_countys

		countys = County.select("id, name").all
		render :json => countys

	end

	def get_county_towns

		county_id = params[:county_id]
		towns = Town.select("id, name, x_lng, y_lat").where("county_id = #{county_id}")

		render :json => towns
	end

end
