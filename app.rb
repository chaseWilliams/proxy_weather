require './weather/loader'
include Geokit::Geocoders

class App < Sinatra::Application

  before do
    content_type 'application/json'
    @w_proxy = Weather_Man::Proxy.new
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  end

  get '/' do
    if params[:mode] == 'zip'
      weather = @w_proxy.weather_is 'zip', params[:zipcode].to_i
      {status: 'ok', data: weather}.to_json
    elsif params[:mode] == 'coordinates'
      geoloc = GoogleGeocoder.reverse_geocode [params[:lat].to_i, params[:lon].to_i]
      zip_code = geoloc.zip
      weather = @w_proxy.weather_is 'zip', zip_code #add city name
      puts "The city is #{geoloc.city}"
      weather.store 'city', geoloc.city
      weather.store 'zipcode', zip_code
      {status: 'ok', data: weather}.to_json
    else
      {status: 'bad_mode'}.to_json
    end
  end
end
