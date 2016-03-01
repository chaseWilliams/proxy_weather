require './weather/loader'
include Geokit::Geocoders

class App < Sinatra::Application

  def initialize
    @w_proxy = Weather_Man::Proxy.new
  end

  before do
    content_type 'application/json'
  end

  get '/' do
    if params[:mode] == 'zip'
      weather = @w_proxy.weather_is 'zip', params[:zipcode].to_i
      {status: 'ok', data: weather}.to_json
    elsif params[:mode] == 'coordinates'
      zip_code = (GoogleGeocoder.reverse_geocode [params[:lat].to_i, params[:lon].to_i]).zip
      weather = @w_proxy.weather_is 'zip', zip_code
      {status: 'ok', data: weather}.to_json
    else
      {status: 'bad_mode'}.to_json
    end
  end
end
