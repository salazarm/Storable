class TransactionsController < ApplicationController
  respond_to :json, :html

  before_filter :require_login

  # GET /users/1/transactions.json
  def index

    @pending_host_transactions = @current_user.host_transactions.where(:host_seen => false)
    @pending_renter_transactions = @current_user.renter_transactions.where(:host_seen => false)

    @past_host_transactions = @current_user.host_transactions.where(:host_seen => true, :host_accepted => true)
    @past_renter_transactions = @current_user.renter_transactions.where(:host_seen => true, :host_accepted => true)

    @transactions = {:pending_host_transactions => @pending_host_transactions, :pending_renter_transactions => @pending_renter_transactions, :past_host_transactions => @past_host_transactions, :past_renter_transactions => @past_renter_transactions}
    respond_with(@transactions, :status => :ok)

  end

  # GET /users/1/transactions/1.json
  def show
    if @current_user.host_transactions.exists?(:id => params[:id])
      @transaction = current_user.host_transactions.find(params[:id])
    elsif @current_user.renter_transactions.exists?(:id => params[:id])
      @transaction = current_user.renter_transactions.find(params[:id])
    else
       respond_with("You are not the host or renter of this transaction", :status => :unprocessable_entity)
    end
    respond_with(@transaction, :status => :ok)
  end

  # POST /user/1/transactions.json
  def create

    listing = Listing.find(params[:listing_id])

    # Add default value of host_accepted => false to transaction
    params[:transaction][:host_accepted] = false
    params[:transaction][:listing_id] = params[:listing_id]
    start_date = params[:transaction][:start_date]
    end_date = params[:transaction][:end_date]

    reservations_conflicts = Listing.joins(:reserved_dates).where(:id => params[:listing_id]).where('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',start_date,start_date).where('(reserved_dates.start_date <= ? AND reserved_dates.end_date >= ?)',end_date,end_date)
  
    if reservations_conflicts.length > 0 || !(listing.start_date <= Date.parse(start_date) && listing.end_date >= Date.parse(start_date)) 
      render :json => { error: ["Your dates are invalid. Someone has already booked for a portion of them."]}
    else 

      @transaction = Transaction.new(params[:transaction])

      
      Transaction.create_transaction_listing(listing, @transaction)
      
      # Update conversation so host sees renter wants to proceed
      # conversation = Conversation.create_or_get_conversation(params, current_user)
      # conversation.request_submit

      @transaction.price = @transaction.calc_price

      if @transaction.save
        render :json => @transaction
      else
        respond_with(@transaction.errors, :status => :unprocessable_entity)
      end
    end

  end

  # Update is only used when the host accepts a renter's request
  def update
    if current_user.host_transactions.exists?(:id => params[:id])
      @transaction = current_user.host_transactions.find(params[:id])

      @transaction.update_attributes({:host_accepted => params[:host_accepted]})
      @transaction.update_attributes({:host_seen => true})

      transaction_listing = @transaction.transaction_listing

      # add the reservation for searching
      listing = Listing.find(transaction_listing.listing_id)
      listing.create_reserved_date(@transaction, listing)

      #### STRIPE PAYMENT HANDLING ####

      # Create the charge on Stripe's servers - this will charge the user's card
      begin
        charge = Stripe::Charge.create(
          :amount => listing.price, # amount in cents
          :currency => "usd",
          :card => @transaction.stripeToken,
          :description => transaction_listing.title
        )
      rescue Stripe::CardError => e
        # The card has been declined
      end

    end
    render :json => true
  end
end
