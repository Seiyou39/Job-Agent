require "net/http"
require "json"

class RentPredictorService
  API_URL = "https://tokyo-rent-predictor-app.onrender.com/predict"

  DEFAULTS = {
    area: 25.0,
    walk: 10.0,
    age: 15.0,
    floor: 3.0,
    total_floors: 8.0,
    layout: "1K"
  }.freeze

  def self.predict(location)
    return nil if location.blank?

    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10

    request = Net::HTTP::Post.new(uri)
    request["content-type"] = "application/json"
    request.body = DEFAULTS.merge(location: location).to_json

    response = http.request(request)
    return nil unless response.is_a?(Net::HTTPSuccess)

    data = JSON.parse(response.body)
    rent = data["predicted_rent"]
    rent&.to_f
  rescue => e
    Rails.logger.warn("RentPredictor failed: #{e.class} #{e.message}")
    nil
  end
end
