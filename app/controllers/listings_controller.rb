class ListingsController < ApplicationController
  respond_to :json
  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @listings }
    end
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
    @listing = current_user.listings.build(params[:listing])

    if @listing.save
      respond_with(@listing, :status => :created)
    else
      respond_with(@listing.errors, :status => :unprocessable_entity)
    end
    
  end

  # PUT /listings/1
  # PUT /listings/1.json
  def update
    @listing = current_user.listings.find(params[:id])

    respond_to do |format|
      if @listing.update_attributes(params[:listing])
        respond_with(@listing, :status => :ok)
      else
        respond_with(@listing.errors, :status => :unprocessable_entity)
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing = current_user.listings.find(params[:id])

    if @listing.destroy
        respond_with :status => :ok
    else
        respond_with(@listing.errors, :status => :unprocessable_entity)
    end
  end
end
