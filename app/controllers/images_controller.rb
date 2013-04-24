class ImagesController < ApplicationController
  before_filter :get_listing 
  respond_to :json

  # POST /images
  # POST /images.json
  def create
    @image = get_parent.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @image = get_parent.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image = get_parent.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  protected
  def get_parent
    case
      when params[:listing_id] then current_user.listings.find_by_id(params[:listing_id]).images
      when current_user.id == params[:user_id] then current_user.image
    end    
  end  
end
