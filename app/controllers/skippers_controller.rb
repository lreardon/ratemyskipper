class SkippersController < ApplicationController
	before_action :redirect_unless_logged_in
	before_action :set_skipper, only: %i[show edit update destroy]

	# GET /skippers or /skippers.json
	def index
		if (q = params[:q]).present?
			q_downcase = q.downcase

			best_match_skippers = Skipper.where("(LOWER(firstname) || ' ' || LOWER(lastname)) LIKE ?||'%'", q_downcase)

			pattern = helpers.sql_similar_to_from_query(q_downcase)

			loose_match_skippers = Skipper.where('LOWER(firstname) SIMILAR TO ?', pattern).or(
				Skipper.where('LOWER(lastname) SIMILAR TO ?', pattern).or(
					Skipper.where('LOWER(boatname) SIMILAR TO ?', pattern)
				)
			)

			@skippers = best_match_skippers | loose_match_skippers
		else
			saved_skippers = current_user.saved_skippers
			@skippers = saved_skippers unless saved_skippers.empty?
		end
	end

	# GET /skippers/1 or /skippers/1.json
	def show
		return unless current_user.reviewed_skipper?(@skipper)

		@review = Review.find_by(author_id: current_user.id, skipper_id: @skipper.id)
	end

	# GET /skippers/new
	def new
		@skipper = Skipper.new
	end

	# GET /skippers/1/edit
	def edit; end

	# POST /skippers or /skippers.json
	def create
		@skipper = Skipper.new(
			creator_id: current_user.id,
			**skipper_params
		)

		respond_to do |format|
			if @skipper.save
				format.html { redirect_to skipper_url(@skipper), notice: 'Skipper was successfully created.' }
				format.json { render :show, status: :created, location: @skipper }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { render json: @skipper.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /skippers/1 or /skippers/1.json
	def update
		respond_to do |format|
			if @skipper.update(skipper_params)
				format.html { redirect_to skipper_url(@skipper), notice: 'Skipper was successfully updated.' }
				format.json { render :show, status: :ok, location: @skipper }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { render json: @skipper.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /skippers/1 or /skippers/1.json
	def destroy
		@skipper.destroy

		respond_to do |format|
			format.html { redirect_to skippers_url, notice: 'Skipper was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private

	# Use callbacks to share common setup or constraints between actions.
	def set_skipper
		@skipper = Skipper.find(params[:id])
	end

	# Only allow a list of trusted parameters through.
	def skipper_params
		puts permitted_params = params.fetch(:skipper, {}).permit(:firstname, :lastname, :boatname, :city, :state)
		permitted_params[:boatname] = helpers.sanitize_boatname(permitted_params[:boatname]) if permitted_params[:boatname]

		permitted_params
	end

	def skippers_params
		params.permit(:q)
	end
end
