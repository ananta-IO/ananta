class ImagesController < InheritedResources::Base
  respond_to :html, :json
  actions :create, :update, :destroy

  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
  	# TODO: UNHACK: This is a hack. I don't know how to store the model's attributes before processing the image in the uploader. This proccesses twice, the first time with no image. 
  	@image = Image.new(pick(params[:image], :image_type, :imageable, :imageable_id, :imageable_type, :name, :lat, :lon))
  	@image.update_attributes(params[:image])

  	create!
  end
end
