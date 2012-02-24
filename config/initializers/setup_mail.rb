# config/initializers/setup_mail.rb


if ["development", "test", "sandbox"].include?(Rails.env.to_s)
  ActionMailer::Base.raise_delivery_errors = true

  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "ananta.io",
    :user_name            => "test-email-account1@ananta.io",
    :password             => "dumbofantarainbowbright",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

  require "development_mail_interceptor"
  ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) # sends all mail to test-email-account1@ananta.io

else
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.sendgrid.net",
    :port                 => 587,
    :domain               => "ananta.io",
    :user_name            => ENV['SENDGRID_USERNAME'],
    :password             => ENV['SENDGRID_PASSWORD'],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }  
end

if Rails.env == "test"
  ActionMailer::Base.delivery_method = :test
end
