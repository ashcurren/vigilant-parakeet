class HomeController < ApplicationController



  def index


  end

  def expedia_query(location, startdate, enddate)

    expedia_key = 'wRhEfj9STYhqVcbFd6yuTyBF2GukBVtD'
    expedia_secret = 'yRpakAdxHIRWjm3D'

    response = HTTParty.get('http://terminal2.expedia.com/x/activities/search?location=' + location + '&startDate=' + startdate + '&endDate=' + enddate + '&apikey=' + expedia_key)

    puts response.body, response.code, response.message, response.headers.inspect

  end

  def uber_query(sLat, sLong, eLat, eLong)

    sLat = sLat.to_s
    sLong = sLong.to_s
    eLat = eLat.to_s
    eLong = eLong.to_s

    response = HTTParty.get('https://api.uber.com/v1/estimates/price?start_latitude='+sLat+'&start_longitude='+sLong+'&end_latitude='+eLat+'&end_longitude='+eLong, headers: {"Authorization" => "Token OOWRpDScLJvhdQm4yUfmA24r_Kz0OKNdoKh7MuC1
s7AlWnIrepGsLoi6db-Oct6DCYrhatz9pmRQ-bOu"})

    puts response.body, response.code, response.message, response.headers.inspect
  end

end
