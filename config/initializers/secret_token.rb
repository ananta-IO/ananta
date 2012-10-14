# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Ananta::Application.config.secret_token = (["development","test"].include?(Rails.env)) ? "26ff2977922bb4bc26b60ba992f9ba32646d6e25dd9f2db7c4d9503d0fb1a4dde7cfab154acbaa3cd92a28d4b6860f1dc346507843e1616a1970ce3fa84dd001" : ENV['SECRET_TOKEN']