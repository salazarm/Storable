class ReviewsController < ApplicationController
	respond_to :json

  before_filter :require_login
  skip_before_filter :index

	# GET /users/1/reviews.json
	# GET /listings/1/reviews.json
  def index
  	if params[:type] == "UserReview"
    	@reviews = Reviews.where("reviewee_id = ?", current_user.id)
    elsif params[:type] == "TransactionReview"
    	@reviews = Reviews.where("listing_id = ?", params[:listing_id])
    end
    respond_with(@reviews, :status => :ok)
  end

  # POST /users/1/reviews.json
  # POST /listings/1/reviews.json
  def create
    if params[:type] == "UserReview"
      user = User.find(params[:user_id])
      if user.can_review(current_user)
        @review = @current_user.user_reviews.build(params[:review])
      end
    elsif params[:type] == "TransactionReview"
      listing = Listing.find(params[:listing_id])
      if listing.can_review(current_user)
        @review = listing.transaction_reviews.build(params[:review])
        @review.listing_id = listing.id
        @review.reviewer_id = current_user.id
        @review.reviewee_id = listing.user_id
        ###TODO fill in all the other fields like transaction id
      end
    end

    if @review.save
      respond_with(listing, @review, :status => :created)
    else
      respond_with(listing, @review.errors, :status => :unprocessable_entity)
    end
  end

  # # PUT /users/1/reviews/1.json
  # # PUT /transactions/1/reviews/1.json
  # def update
  #   if params[:type] == "UserReview"
  #     @review = @current_user.user_reviews.find(params[:id])
  #   elsif params[:type] == "TransactionReview"
  #     @review = @current_user.transaction_reviews.find(params[:id])
  #   end

  #   if @review.update_attributes(params[:review])
  #     render :json => @listing
  #   else
  #     respond_with(@review.errors, :status => :unprocessable_entity)
  #   end
  # end

  # # DELETE /users/1/reviews/1.json
  # # DELETE /transactions/1/reviews/1.json
  # def destroy
  #   if params[:type] == "UserReview"
  #     @review = @current_user.user_reviews.find(params[:id])
  #   elsif params[:type] == "TransactionReview"
  #     @review = @current_user.transaction_reviews.find(params[:id])
  #   end

  #   if @review.destroy
  #       respond_with :status => :ok
  #   else
  #       respond_with(@review.errors, :status => :unprocessable_entity)
  #   end
  # end

end