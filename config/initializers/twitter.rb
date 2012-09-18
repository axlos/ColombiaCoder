require 'twitter'

twitter_config = YAML.load(File.read(Rails.root.join('config', 'twitter.yml')))[Rails.env]

Twitter.configure do |config|
  config.consumer_key = 'lEWD39p0yfH0wyrxnCXKQ'
  config.consumer_secret = 'FXbv7bzrn8u0hC6Y01aKCEjrPiCQQRQaJMi1ejr1SR8'
  config.oauth_token = twitter_config['oauth_token']
  config.oauth_token_secret = twitter_config['oauth_token_secret']
end