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
    "uploads/images/#{model.image_type.pluralize}/#{model.class.to_s.underscore}/#{model.id}"
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

    "/assets/fallback/" + params.compact.join('_')
  end

  version :small do
    process :resize_to_fill => [64, 64]
    process :quality => 60
  end

  version :medium do
    process :resize_to_fill => [256, 256]
    process :quality => 60
  end

  version :large do
    process :resize_to_fit => [512, 512]
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