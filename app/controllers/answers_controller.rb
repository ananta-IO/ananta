class AnswersController < InheritedResources::Base
  respond_to :html, :json

  # before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource
end
