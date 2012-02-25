class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])

    populate_tags
  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:success] = 'Profile was successfully updated.'
        format.html { redirect_to @profile }
        format.json { head :ok }
      else
        populate_tags
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url }
      format.json { head :ok }
    end
  end

  protected

  def populate_tags
    @bio_tags = Profile.tag_counts_on(:bio_tags).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}
    @skills = Profile.tag_counts_on(:skills).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}
    @needs = Profile.tag_counts_on(:needs).where("name like ?", "%#{params[:q]}%").map{|t| {:id => t.name, :name => t.name}}

    @selected_bio_tags = @profile.bio_tags.map{|t| {:id => t.name, :name => t.name}}
    @selected_skills = @profile.skills.map{|t| {:id => t.name, :name => t.name}}
    @selected_needs = @profile.needs.map{|t| {:id => t.name, :name => t.name}}
  end

end
