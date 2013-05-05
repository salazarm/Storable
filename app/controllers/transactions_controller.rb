class TransactionsController < ApplicationController
  respond_to :json

  before_filter :require_login

  # GET /users/1/transactions.json
  def index
    @transactions = current_user.host_transactions + current_user.renter_transactions
    respond_with(@transactions.to_json, :status => :ok)
  end

  # GET /users/1/transactions/1.json
  def show
    if current_user.host_transactions.exists?(:id => params[:id])
      @transaction = current_user.host_transactions.find(params[:id])
    elsif current_user.renter_transactions.exists?(:id => params[:id])
      @transaction = current_user.renter_transactions.find(params[:id])
    end
    respond_with(@transaction, :status => :ok)
  end

  # POST /user/1/transactions.json
  def create

    # Add default value of host_accepted => false to transaction
    params[:transaction][:host_accepted] = false

    @transaction = Transaction.new(params[:transaction])

    listing = Listing.find(params[:listing_id])
    Transaction.create_transaction_listing(listing, @transaction)

    # Update conversation so host sees renter wants to proceed
    conversation = Conversation.create_or_get_conversation(params, current_user)
    conversation.request_submit

    if @transaction.save
      respond_with(@transaction, :status => :created)
    else
      respond_with(@transaction.errors, :status => :unprocessable_entity)
    end

  end

  # Update is only used when the host accepts a renter's request
  def update
    if current_user.host_transactions.exists?(:id => params[:id])
      @transaction = current_user.host_transactions.find(params[:id])

      @transaction.update_attributes({:host_accepted => params[:host_accepted]})

      transaction_listing = @transaction.transaction_listing

      # add the reservation for searching
      listing = Listing.find(transaction_listing.listing_id)
      listing.create_reserved_date(@transaction, listing)

      #### STRIPE PAYMENT HANDLING ####

      Stripe.api_key = "sk_test_y5dqWUhct4bMB66OxMiqNY3G"

      # Create the charge on Stripe's servers - this will charge the user's card
      begin
        charge = Stripe::Charge.create(
          :amount => transaction_listing.price, # amount in cents
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
