class ImagesController < ApplicationController
  before_filter :get_parent 
  respond_to :json

  # create an image and associate it with its parent
  def create
    @image = @parent.images.build(params[:image])

    if @image.save
      respond_with(@parent, @image, :status => :created)
    else
      respond_with(@parent, @image.errors, :status => :unprocessable_entity)
    end
  end

  # delete an image
  def destroy
    @image = @parent.images.find(params[:id])

    if @image.destroy
        respond_with :status => :ok
    else
        respond_with(@parent, @image.errors, :status => :unprocessable_entity)
    end

  end

  protected
  # get the parent of the image
  # NOTE: this will either be a listing or a user
  def get_parent
    case
      when params[:listing_id] 
        @parent = current_user.listings.find(params[:listing_id])
      when current_user.id == params[:user_id].to_i
        @parent = current_user
    end    
  end  
end
