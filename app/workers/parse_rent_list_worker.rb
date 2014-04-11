class ParseRentListWorker
  include Sidekiq::Worker
  sidekiq_options queue: "house"

  def perform(raw_list_id)
    raw_list = RawRentList.find(raw_list_id)
	raw_list_parser = RawListParser.new
	raw_list_parser.parse_rent_list raw_list
  end
end