class ImagesController < ApplicationController
  before_filter :build_image_param, :only => [:create]
  load_and_authorize_resource

  def create
    @image = Image.new(params[:image])
    if @image.save
      render :json => [@image.to_jq_upload].to_json
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      render :json => [@image.to_jq_upload].to_json
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    
    respond_to do |format|
      format.json { render :json => true }
    end
  end

  private

  def build_image_param
    nested_image = params[:image][:image] rescue nil
    params[:image] = { :image => params[:image], :imageable_type => params[:imageable_type], :imageable_id => params[:imageable_id], :image_type => params[:image_type]} unless nested_image
  end

end
