class ImagesController < ApplicationController
  before_filter :get_parent 
  respond_to :json

  # POST /images
  # POST /images.json
  def create
    @image = @parent.images.build(params[:image])

    if @image.save
      respond_with(@parent, @image, :status => :created)
    else
      respond_with(@parent, @image.errors, :status => :unprocessable_entity)
    end
  end

  def update
    @image = @parent.images.find(params[:id])

    if @image.update_attributes(params[:image])
      respond_with(@parent, @image, :status => :ok)
    else
      respond_with(@parent, @image.errors, :status => :unprocessable_entity)
    end

  end

  def destroy
    @image = @parent.images.find(params[:id])

    if @image.destroy
        respond_with :status => :ok
    else
        respond_with(@parent, @image.errors, :status => :unprocessable_entity)
    end

  end

  protected
  def get_parent
    case
      when params[:listing_id] 
        @parent = current_user.listings.find(params[:listing_id])
      when current_user.id == params[:user_id].to_i
        @parent = current_user
    end    
  end  
end
