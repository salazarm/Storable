class ListingsController < ApplicationController
  respond_to :json, :html
  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all
     respond_with(@listings, :status => :ok)
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    @listing = Listing.find(params[:id])
    respond_with(@listing, :status => :ok)
  end

  # POST /listings
  # POST /listings.json
  def create
   @listing = @current_user.listings.build(params[:listing])

    if @listing.save
      respond_with(@listing, :status => :created)
    else
      respond_with(@listing.errors, :status => :unprocessable_entity)
    end
  end

  def edit
    @listing = Listing.find_by_id(params[:id])
    respond_with(@listing, :status => :ok)
  end
  
  def new
    require_login
    @listing = Listing.new
    @listing.location = Location.new
  end

  # PUT /listings/1
  # PUT /listings/1.json
  def update
    require_login
    @listing = @current_user.listings.find(params[:id])
    if @listing.update_attributes(params[:listing])
      render :json => @listing
      # respond_with(@listing, :status => :ok)
    else
      respond_with(@listing.errors, :status => :unprocessable_entity)
    end
    
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = @current_user.listings.find(params[:id])

    if @listing.destroy
        respond_with :status => :ok
    else
        respond_with(@listing.errors, :status => :unprocessable_entity)
    end
  end
end
