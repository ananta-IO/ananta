# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  if %w[development test].include? Rails.env
    storage :file
  else
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore.pluralize}/#{model.image_type.pluralize}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    params = []

    params.push version_name
   
    if model.imageable_type
      params.push model.imageable_type.underscore
    else
      params.push model.class.to_s.underscore
    end

    params.push "#{model.image_type}.png"

    "http://#{ActionMailer::Base.default_url_options[:host]}/assets/fallback/" + params.compact.join('_')
  end

  version :small do
    process :resize_to_fill => [70, 70]
    process :quality => 60
  end

  version :medium do
    process :resize_to_fill => [370, 370]
    process :quality => 70
  end

  version :large do
    process :resize_to_fit => [570, 570]
    process :quality => 60
  end 

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
   %w(jpg jpeg png gif)
  end

  def filename
    @name ||= "#{secure_token}.#{file.extension}" if original_filename
  end

  private

  def secure_token
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(8))
  end

end
