# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# encoding: UTF-8

c = County.new
c.name = "基隆市"
c.county_web_id = 2
c.save 

c = County.new
c.name = "台北市"
c.county_web_id = 1
c.save 

c = County.new
c.name = "新北市"
c.county_web_id = 3
c.save 

c = County.new
c.name = "桃園縣"
c.county_web_id = 6
c.save 

c = County.new
c.name = "新竹市"
c.county_web_id = 4
c.save 

c = County.new
c.name = "新竹縣"
c.county_web_id = 5
c.save

c = County.new
c.name = "苗栗縣"
c.county_web_id = 7
c.save 

c = County.new
c.name = "台中市"
c.county_web_id = 8
c.save 

c = County.new
c.name = "南投縣"
c.county_web_id = 11
c.save 

c = County.new
c.name = "彰化縣"
c.county_web_id = 10
c.save 

c = County.new
c.name = "雲林縣"
c.county_web_id = 14
c.save 

c = County.new
c.name = "嘉義市"
c.county_web_id = 12
c.save

c = County.new
c.name = "嘉義縣"
c.county_web_id = 13
c.save 

c = County.new
c.name = "台南市"
c.county_web_id = 15
c.save 

c = County.new
c.name = "高雄市"
c.county_web_id = 17
c.save 

c = County.new
c.name = "屏東縣"
c.county_web_id = 19
c.save 

c = County.new
c.name = "宜蘭縣"
c.county_web_id = 21
c.save 

c = County.new
c.name = "花蓮縣"
c.county_web_id = 23
c.save 

c = County.new
c.name = "臺東縣"
c.county_web_id = 22
c.save

c = County.new
c.name = "澎湖縣"
c.county_web_id = 24
c.save 

c = County.new
c.name = "金門縣"
c.county_web_id = 25
c.save 

c = County.new
c.name = "連江縣"
c.county_web_id = 26
c.save 

b = BuildingType.new
b.name = "公寓"
b.save

b = BuildingType.new
b.name = "電梯大樓"
b.save

b = BuildingType.new
b.name = "透天"
b.save

b = BuildingType.new
b.name = "其他"
b.save

# b = BuildingType.new
# b.name = "別墅"
# b.save

g = GroundType.new
g.name = "住宅"
g.save

g = GroundType.new
g.name = "其他"
g.save























