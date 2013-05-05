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
    else
      respond_with(@listing.errors, :status => :unprocessable_entity)
    end
    
  end

  def search
    address = params[:address]
    radius = params[:radius]


    @locations = Location.near(address, radius)
    @listings = []
    @locations.each do |location| 
      @listings.push(location.listing)
    end

    if params.has_key?(:start_date) && params.has_key?(:end_date)
      start_date = params[:start_date]
      end_date = params[:end_date]

      #a = Listing.joins(:reserved_dates).where('listings.start_date <= ? AND listings.end_date >= ?','2013-05-10','2013-05-20').having('(reserved_dates.start_date >= ? AND reserved_dates.start_date <= ?) OR (reserved_dates.end_date >= ? AND reserved_dates.end_date <= ?)','2013-05-10','2013-05-20','2013-05-10','2013-05-20').group('listings.id')

      #find all listings which have reserved dates that conflict with my given start and end dates
      a = Listing.joins(:reserved_dates).where('listings.start_date <= ? AND listings.end_date >= ?',start_date,end_date).having('(reserved_dates.start_date >= ? AND reserved_dates.start_date <= ?) OR (reserved_dates.end_date >= ? AND reserved_dates.end_date <= ?)',start_date,end_date,start_date,end_date).group('listings.id')

      @listings = @listings - a

    end

    render :json => @listings
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
