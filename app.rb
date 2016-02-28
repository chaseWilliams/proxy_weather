require './weather/loader'
include Geokit::Geocoders
class App < Sinatra::Application

  before do
    content_type 'application/json'
  end

  get '/weather' do
    if params[:mode] = 'zip'
      weather = Weather_man.get_weather_zip params[:zip_code].to_i
      {status: 'ok', data: weather}.to_json
    elsif params[:mode] = 'coordinates'
      zip_code = (GoogleGeocoder.reverse_geocode [params[:lat].to_i, params[:lon].to_i]).zip
      weather = Weather_man.get_weather_zip zip_code
      {status: 'ok', data: weather}.to_json
    else
      {status: 'bad_mode'}.to_json
    end
  end
end
