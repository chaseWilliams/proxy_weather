
#this module allows for a weather data fetch, supplied via the getWeather method.
module Weather_Man
  class Proxy
    def initialize
      @redis = Redis.new(url: ENV['REDIS_URI'])
      @logger_out = Logger.new(STDOUT)
      @logger_err = Logger.new(STDERR)
    end

    def weather_is mode, geo
      @logger_out.info "The result for 'exists' is #{@redis.exists 'weather_data'}"
      if !@redis.exists('weather_data')
        mode == 'zip' ? identifier = "zip=#{geo}" : identifer = "id=#{geo}"
        response = openweathermap identifier
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
        @redis.set 'weather_data', weather_data.to_json
        @redis.expire 'weather_data', 600
        @logger_out.info "Request made! weather_data's class is #{weather_data.class}
        and the result is #{weather_data}"
        return weather_data
      else
        data = JSON.parse @redis.get('weather_data')
        @logger_out.info "Data fetched from Redis (#{data}), with
        #{@redis.ttl('weather_data')} left on it's expiration. Class is #{data.class}"
        return data
      end
    end
    def openweathermap params
      return JSON.parse RestClient.get 'http://api.openweathermap.org/data/2.5/weather?' + params + "&APPID=#{ENV['OWM_KEY']}"
    end
    private :openweathermap
  end
end
