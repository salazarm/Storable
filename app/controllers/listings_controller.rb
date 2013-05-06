class ListingsController < ApplicationController
  respond_to :json, :html
  
  #get all the listings
  def index
    @listings = Listing.all
     respond_with(@listings, :status => :ok)
  end

  #show details for a particular listing
  def show
    @listing = Listing.find(params[:id])
    respond_with(@listing, :status => :ok)
  end

  #create a listing for this user
  def create
   @listing = @current_user.listings.build(params[:listing])

    if @listing.save
      respond_with(@listing, :status => :created)
    else
      respond_with(@listing.errors, :status => :unprocessable_entity)
    end
  end

  #edit a particular listing
  def edit
    @listing = Listing.find_by_id(params[:id])
    respond_with(@listing, :status => :ok)
  end
    
  #define a new listing
  def new
    require_login
    @listing = Listing.new
    @listing.location = Location.new
  end

  #update the details of a listing
  def update
    require_login
    @listing = @current_user.listings.find(params[:id])
    if @listing.update_attributes(params[:listing])
      render :json => @listing
    else
      respond_with(@listing.errors, :status => :unprocessable_entity)
    end
    
  end

  #search for listings based on various parameters
  def search
   @listings = Listing.search(params)
   puts @listings
   render :json => @listings
  end

  #delete a listing
  def destroy
    @listing = @current_user.listings.find(params[:id])

    if @listing.destroy
        respond_with :status => :ok
    else
        respond_with(@listing.errors, :status => :unprocessable_entity)
    end
  end
end
