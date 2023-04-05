class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]

  # GET /reviews or /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1 or /reviews/1.json
  def show; end

  # GET /reviews/new
  def new
    skipper_id = review_params[:skipper_id]
    raise AlreadyExistsError if current_user.authored_reviews.map(&:skipper_id).include?(skipper_id)

    @review = Review.new
    @skipper = Skipper.find(skipper_id)
  end

  # GET /reviews/1/edit
  def edit
    @skipper = @review.skipper
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)
    @skipper = Skipper.find(review_params[:skipper_id])

    respond_to do |format|
      if @review.save
        format.html { redirect_to skipper_url(@skipper), notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to skipper_url(@review.skipper), notice: 'Review was successfully created.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy

    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    @review = Review.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def review_params
    puts 'params'
    puts params
    params.fetch(:review, {}).permit(:skipper_id, :author_id, :reckless, :aggressive, :did_not_pay, :would_return,
                                     :comment)
  end
end