class ReviewsController < ApplicationController
	respond_to :json

  before_filter :require_login
  skip_before_filter :index

	#list all the reviews this user has received
  def index
    #show all user reviews
  	if params[:type] == "UserReview"
    	@reviews = Review.where("reviewee_id = ?", current_user.id)
    #show all listing reviews
    elsif params[:type] == "TransactionReview"
    	@reviews = Review.where("listing_id = ?", params[:listing_id])
    end
    respond_with(@reviews, :status => :ok)
  end

  #create a review for either a user or a listing
  def create
    #check if user can still review this user. If so then create the review. 
    if params[:type] == "UserReview"
      user = User.find(params[:user_id])
      if user.can_review(current_user)
        @review = @current_user.user_reviews.build(params[:review])
      end
    #check if user can still review this listing. If so, then create review
    elsif params[:type] == "TransactionReview"
      listing = Listing.find(params[:listing_id])
      if listing.can_review(current_user)
        #fill in relevant fields
        @review = listing.transaction_reviews.build(params[:review])
        @review.listing_id = listing.id
        @review.reviewer_id = current_user.id
        @review.reviewee_id = listing.user_id
      end
    end

    if @review.save
      respond_with(listing, @review, :status => :created)
    else
      respond_with(listing, @review.errors, :status => :unprocessable_entity)
    end
  end



end