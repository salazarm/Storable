class LocationsController < ApplicationController
  before_filter :get_listing
  respond_to :json

  # POST /locations
  # POST /locations.json
  def create
    @location = @listing.build_location(params[:location])

    if @location.save
      respond_with(@listing, @location, :status => :created)
    else
      respond_with(@listing, @location, :status => :unprocessable_entity)
    end

  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = @listing.location

    if @location.update_attributes(params[:location])
      respond_with(@listing, @location, :status => :ok)
    else
      respond_with(@listing, @location, :status => :unprocessable_entity)
    end

  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location = @listing.location

    if @location.destroy
        respond_with :status => :ok
    else
        respond_with(@listing, @location, :status => :unprocessable_entity)
    end

  end

  #gets the listing associated with this listing_id, for this current user
  protected
  def get_listing
      @listing = current_user.listings.find(params[:listing_id]) if params[:listing_id]
      redirect_to root_url unless defined?(@listing)
  end

end
