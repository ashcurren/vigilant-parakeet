class SearchController < ApplicationController

  def index

  end

  def run_search

  end

  def expedia_query(location, startdate, enddate)

    expedia_key = 'wRhEfj9STYhqVcbFd6yuTyBF2GukBVtD'
    expedia_secret = 'yRpakAdxHIRWjm3D'

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

    expedia_array.push expedia_results
    end

    #puts response.body, response.code, response.message, response.headers.inspect

  end

  def details_query(id, startdate, enddate)
    expedia_key = 'wRhEfj9STYhqVcbFd6yuTyBF2GukBVtD'
    expedia_secret = 'yRpakAdxHIRWjm3D'

    response = HTTParty.get('http://terminal2.expedia.com/x/activities/details?activityId=' + id.to_s + '&startDate=' + startdate + '&endDate=' + enddate + '&apikey=' + expedia_key)

    expedia_details_hash = JSON.parse response.body

    expedia_details_imgUrl = expedia_details_hash["images"].first["url"]
    expedia_details_des = ActionController::Base.helpers.sanitize expedia_details_hash["description"], tags: []
    expedia_details_title = expedia_details_hash["title"]

    expedia_load = Hash.new()
    expedia_load[:imageUrl] = expedia_details_hash
    expedia_load[:description] = expedia_details_des
    expedia_load[:title] = expedia_details_title

    expedia_load

  end

  def uber_query(sLat, sLong, eLat, eLong)

    sLat = sLat.to_s
    sLong = sLong.to_s
    eLat = eLat.to_s
    eLong = eLong.to_s

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



end
