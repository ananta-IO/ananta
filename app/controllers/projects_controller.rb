class ProjectsController < InheritedResources::Base
  respond_to :js, :html, :json
  belongs_to :user
  defaults :route_prefix => ''

  before_filter :authenticate_user!
  load_and_authorize_resource
end