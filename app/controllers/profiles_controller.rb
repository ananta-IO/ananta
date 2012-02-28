class ProfilesController < InheritedResources::Base
  respond_to :html, :json
  actions :show, :edit, :update
  before_filter :populate_tags, :only => [:edit, :update]

  before_filter :authenticate_user!
  load_and_authorize_resource

  protected

  def populate_tags
    @profile = Profile.find(params[:id])
    
    @tags = {}
    @tags['bio_tags'] = Profile.tag_counts_on(:bio_tags).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}
    @tags['skills'] = Profile.tag_counts_on(:skills).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}
    @tags['needs'] = Profile.tag_counts_on(:needs).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}

    @selected_tags = {}
    @selected_tags['bio_tags'] = @profile.bio_tags.map{|t| {:id => t.name, :name => t.name}}
    @selected_tags['skills'] = @profile.skills.map{|t| {:id => t.name, :name => t.name}}
    @selected_tags['needs'] = @profile.needs.map{|t| {:id => t.name, :name => t.name}}
  end

end
