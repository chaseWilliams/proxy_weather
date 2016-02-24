#weather.rb
require 'rest-client'
require File.expand_path('../flickr.rb', __FILE__)
include Flickrd

#this module allows for a weather data fetch, supplied via the getWeather method.
module Weather_man
  def self.getWeather cityID
    response = openweathermap "id=#{cityID}"
    weather_data = {
      temp: (1.8*(response['main']['temp'].to_f-273)+32).round,
      cloudiness: response['clouds']['all'].to_f.round,
      humidity: response['main']['humidity'].to_f.round,
      windiness: response['wind']['speed'].to_f.round(1),
      condition_id: response['weather'][0]['id'].to_i,
      condition_name: response['weather'][0]['main'],
      condition_description: response['weather'][0]['description'],
      condition_img: response['weather'][0]['icon']
    }
    return weather_data
  end

  def self.get_weather_zip zip_code
    response = openweathermap "zip=#{zip_code}"
    weather_data = {
      temp: (1.8*(response['main']['temp'].to_f-273)+32).round,
      cloudiness: response['clouds']['all'].to_f.round,
      humidity: response['main']['humidity'].to_f.round,
      windiness: response['wind']['speed'].to_f.round(1),
      condition_id: response['weather'][0]['id'].to_i,
      condition_name: response['weather'][0]['main'],
      condition_description: response['weather'][0]['description'],
      condition_img: response['weather'][0]['icon']
    }
    return weather_data
  end

  def self.openweathermap params
    return JSON.parse RestClient.get 'http://api.openweathermap.org/data/2.5/weather?' + params + '&APPID=bd43836512d5650838d83c93c4412774'
  end

  class << self
    private :openweathermap
  end
end
