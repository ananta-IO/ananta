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

  process :convert => 'png'

  version :small do
    process :small_process
  end

  version :medium do
    process :medium_process
  end

  version :large do
    process :large_process
  end

  def small_process
    case [model.imageable_type, model.image_type]
    when ['Profile', 'avatar'] then
      resize_to_fill 128, 128 # 1x1
    when ['Project', 'avatar'] then
      resize_to_fill 128, 72 # 16x9
    else
      resize_to_fit 128, 128 # 1x1
    end
    quality 60
  end 

  def medium_process
    case[model.imageable_type, model.image_type]
    when ['Profile', 'avatar'] then
      resize_to_fill 512, 512
    when ['Project', 'avatar'] then
      resize_to_fill 512, 288
    else
      resize_to_fit 512, 512
    end
    quality 70
  end

  def large_process
    case [model.imageable_type, model.image_type]
    when ['Profile', 'avatar'] then 
      resize_to_fill 1024, 1024
    when ['Project', 'avatar'] then
      resize_to_fill 1024, 576
    else
      resize_to_fit 1024, 1024
    end
    quality 80
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
