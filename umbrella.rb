# Write your solution below!
require "http"
require "json"
require "dotenv/load"

puts "Will you need an umbrella today?"
puts "Where are you?"
location = gets.chomp
#location = "Chicago Loop Millenium Park"
puts "Checking the weather at #{location}...."
location = location.gsub(" ","%20")
google_maps_url = "https://maps.googleapis.com/maps/api/geocode/json" + "?address=#{location}"+"&key=#{ENV.fetch("GMAPS_KEY")}"
maps_response_raw = HTTP.get(google_maps_url)
maps_response_parsed = JSON.parse(maps_response_raw)
#pp maps_response_parsed.fetch("results")[0]
lat = maps_response_parsed.fetch("results")[0].fetch("geometry").fetch("location").fetch("lat")
long = maps_response_parsed.fetch("results")[0].fetch("geometry").fetch("location").fetch("lng")

# pirate weather code
pirate_weather_url = "https://api.pirateweather.net/forecast/" +"#{ENV.fetch("PIRATE_WEATHER_KEY")}"+"/#{lat}"+",#{long}"
pweather_response_raw = HTTP.get(pirate_weather_url)
pweather_response_parsed = JSON.parse(pweather_response_raw)
current_temp = pweather_response_parsed.fetch("currently").fetch("temperature")
nexthour_summary = pweather_response_parsed.fetch("minutely").fetch("summary")
puts "Your coordinates are #{lat},#{long}."
puts "It is currently #{current_temp}."
puts "Next hour: #{nexthour_summary}"

hourly = pweather_response_parsed.fetch("hourly").fetch("data")
twelve_hours = hourly[1..12]
prob_threshold = 0.10
any_precipitation = false

twelve_hours.each do |hour_hash|
  prob = hour_hash.fetch("precipProbability")

  if prob > prob_threshold
    any_precipitation = true
    precip_time = Time.at(hour_hash.fetch("time"))
    seconds= precip_time - Time.now
    hours = seconds / 60 / 60
    puts "In #{hours.round} hours, there is a #{(prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
