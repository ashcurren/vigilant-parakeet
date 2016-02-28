class SearchController < ApplicationController
  before_filter :set_expedia_id_arrays
  include ActionView::Helpers::TextHelper

  def recommendation
    @rec_array = expedia_search_query
  end

  def index
    #  @results = expedia_search_query(@expedia_ids_all)
     @descriptions = []
     @day1 = []
     @day2 = []
     @day3 = []
     #@expedia_ids_all.each {|x| @descriptions.push expedia_detail_query x }

    @expedia_ids_day1.each {|x| @day1.push expedia_detail_query x }
    @expedia_ids_day2.each {|x| @day2.push expedia_detail_query x }

    @day1_uberinfo = []
    @day2_uberinfo = []

    @day1.each_with_index do |d,i|
      @day1_uberinfo.push(uber_detail_query(@day1[i][:latLng],@day1[i+1][:latLng])) if (i+1) != @day1.size
    end

    @day2.each_with_index do |d,i|
      @day2_uberinfo.push(uber_detail_query(@day2[i][:latLng],@day2[i+1][:latLng])) if (i+1) != @day2.size
    end


    # @expedia_ids_day3.each {|x| @day3.push expedia_detail_query x }
    #
    # @day2.each_with_index do |d,i|
    #    @day1_uberinfo.push(uber_detail_query(@day2[i][:latLng],@day2[i+1][:latLng])) if (i+1) != @day2.size
    #  end

  end

  def generate_rec_html
    # this will return the full results for each day, one array per day.
    expedia_search_query()

  end

  def expedia_search_query(ids_to_filter=[], location='New York', startdate='2016-03-01', enddate='2016-03-04')

    expedia_key = 'wRhEfj9STYhqVcbFd6yuTyBF2GukBVtD'
    expedia_secret = 'yRpakAdxHIRWjm3D'

    ids_to_filter = ids_to_filter.map(&:to_s)

    response = HTTParty.get('http://terminal2.expedia.com/x/activities/search?location=' + location + '&startDate=' + startdate + '&endDate=' + enddate + '&apikey=' + expedia_key)

    expedia_hash = JSON.parse response.body

    expedia_array = Array.new()

    expedia_hash["activities"].map do |e|
    expedia_results = Hash.new()
    expedia_results[:title] = e["title"]
    expedia_results[:id] = e["id"]
    expedia_results[:imageUrl] = e["imageUrl"]
    expedia_results[:latLng] = e["latLng"]
    expedia_results[:title] = e["title"]
    expedia_results[:fromPrice] = e["fromPrice"]
    expedia_results[:latLng] = e["latLng"]

    expedia_array.push expedia_results
    @i = @i + 1
    break if @i == 10
    end

    @i = 0

    expedia_array
    #puts response.body, response.code, response.message, response.headers.inspect
  end

  def expedia_detail_query(id)
    expedia_key = 'wRhEfj9STYhqVcbFd6yuTyBF2GukBVtD'
    expedia_secret = 'yRpakAdxHIRWjm3D'

    response = HTTParty.get('http://terminal2.expedia.com/x/activities/details?activityId=' + id.to_s + '&apikey=' + expedia_key)

    expedia_details_hash = JSON.parse response.body

    expedia_details_imgUrl = expedia_details_hash["images"].first["url"]
    expedia_details_des = ActionController::Base.helpers.sanitize expedia_details_hash["description"], tags: []
    expedia_details_title = expedia_details_hash["title"]
    expedia_details_latLng = expedia_details_hash["latLng"]
    expedia_details_price = expedia_details_hash["fromPrice"]
    expedia_details_duration = expedia_details_hash["duration"]

    expedia_load = Hash.new()
    expedia_load[:imageUrl] = expedia_details_imgUrl
    expedia_load[:description] = truncate(expedia_details_des, length: 250, separator: ' ', omission: '... (continued)')
    expedia_load[:title] = expedia_details_title
    expedia_load[:latLng] = expedia_details_latLng
    expedia_load[:price] = expedia_details_price
    expedia_load[:duration] = expedia_details_duration

    expedia_load

  end

  def uber_detail_query(sLatLong, eLatLong)

    sLat = sLatLong.split(",")[0]
    sLong = sLatLong.split(",")[1]
    eLat = eLatLong.split(",")[0]
    eLong = eLatLong.split(",")[1]

    response = HTTParty.get('https://api.uber.com/v1/estimates/price?start_latitude='+ sLat +'&start_longitude='+ sLong +'&end_latitude='+ eLat +'&end_longitude='+ eLong, headers: {"Authorization" => "Token OOWRpDScLJvhdQm4yUfmA24r_Kz0OKNdoKh7MuC1
s7AlWnIrepGsLoi6db-Oct6DCYrhatz9pmRQ-bOu"})

    uber_hash = JSON.parse response.body

    #first result returned is the UberX pricing
    price = uber_hash["prices"].first["estimate"]
    miles = uber_hash["prices"].first["distance"]
    seconds = uber_hash["prices"].first["duration"]
    mins = seconds/60

    uber_details = Hash.new()
    uber_details[:price] = price
    uber_details[:miles] = miles
    uber_details[:mins] = mins

    uber_details

    #puts response.body, response.code, response.message, response.headers.inspect
  end

private

  def set_expedia_id_arrays

    @i = 0

    @expedia_ids_all = [184465,
        278043,
        248963,
        183011,
        288771,
        183749,
        319430,
        326328,
        266375,
        279949,
        184423,
        185654,
        185464,
        183611,
        183421,
        274379]

      @expedia_ids_day1 = [184465,
        278043,
        248963]

      @expedia_ids_day2 = [185464,
        183611,
        183421,
        274379]

      @expedia_ids_day3 = [266375,
        279949,
        184423]

  end

end
