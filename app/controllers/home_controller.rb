class HomeController < ApplicationController



  def index


  end

  def expedia_query(location, startdate, enddate)
    puts "jason sucks"

    expedia_key = 'wRhEfj9STYhqVcbFd6yuTyBF2GukBVtD'
    expedia_secret = 'yRpakAdxHIRWjm3D'

    response = HTTParty.get('http://terminal2.expedia.com/x/activities/search?location=' + location + '&startDate=' + startdate + '&endDate=' + enddate + '&apikey=' + expedia_key)

    puts response.body, response.code, response.message, response.headers.inspect

    puts "maybe he doesn't suck after all"
  end


end
