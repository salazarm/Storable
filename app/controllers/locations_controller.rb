class LocationsController < ApplicationController
  before_filter :get_listing
  respond_to :json

  # POST /locations
  # POST /locations.json
  def create
    @location = @listing.location.build(params[:location])

    respond_to do |format|
      if @location.save
        respond_with(@location, :status => :created)
      else
        respond_with(@location.errors, :status => :unprocessable_entity)
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = @listing.location

    respond_to do |format|
      if @location.update_attributes(params[:location])
        respond_with(@location, :status => :ok)
      else
        respond_with(@location.errors, :status => :unprocessable_entity)
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    if @listing.location.destroy
        respond_with :status => :ok
    else
        respond_with(@location.errors, :status => :unprocessable_entity)
    end

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  #gets the listing associated with this listing_id, for this current user
  protected
  def get_listing
      @listing = current_user.listings.find(params[:listing_id]) if params[:listing_id]
      redirect_to root_url unless defined?(@listing)
  end

end
