FantasticRobot.configure do |config|
  # Secret token of the API
  config.api_key = ENV['TELEGRAM_API_TOKEN']

  # Delivery method (can be :polling or :webhook)
  config.delivery_method = :webhook

  # Callback URL of the webhook
  config.callback_url = "https://#{ENV['TELEGRAM_API_CALLBACK_HOST']}/receive/#{ENV['TELEGRAM_API_CALLBACK_PATH']}"
end

# FantasticRobot.initialize! if(defined?(::Thin) || defined?(::Unicorn) || defined?(::Passenger) || defined?(::Puma))
