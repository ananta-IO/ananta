CarrierWave.configure do |config|
  unless %w[development test].include? Rails.env
    # Amazon S3 configuration
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'us-east-1'
    }

    config.fog_directory  = "ananta-#{Rails.env}"

    # config.fog_host       = 'https://assets.example.com'
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}

    # Heroku workaround
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  end
end



module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end
