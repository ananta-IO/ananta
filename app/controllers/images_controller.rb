class ImagesController < InheritedResources::Base
  respond_to :html, :json
  actions :create, :update, :destroy

  before_filter :authenticate_user!
  load_and_authorize_resource
end
