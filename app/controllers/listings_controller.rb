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

    #first filter by locations within radius miles of the given address
    @locations = Location.near(address, radius)

    #if start date is passed in as a paramter then filter by that as well
    if params.has_key?(:start_date)
       start_date = params[:start_date]


       @locations = @locations.joins(:listing).where('listings.start_date <= ?', start_date).group('listings.id')

       @exclusions_start = Listing.joins(:reserved_dates).having('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',start_date,start_date).group('listings.id')
    end

    if params.has_key?(:end_date)
       end_date = params[:end_date]
       @locations = @locations.joins(:listing).where('listings.end_date >= ?', end_date).group('listings.id')

       @exclusions_end = Listing.joins(:reserved_dates).having('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',end_date,end_date).group('listings.id')
    end

    if defined?(@exclusions_start)
      @locations = @locations - @exclusions_start
    elsif 
      @locations = @locations - @exclusions_end
    end

   render :json => @locations
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
