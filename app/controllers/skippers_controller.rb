class SkippersController < ApplicationController
  before_action :set_skipper, only: %i[show edit update destroy]

  # GET /skippers or /skippers.json
  def index
    @skippers = Skipper.all
  end

  # GET /skippers/1 or /skippers/1.json
  def show; end

  # GET /skippers/new
  def new
    @skipper = Skipper.new
  end

  # GET /skippers/1/edit
  def edit; end

  # POST /skippers or /skippers.json
  def create
    @skipper = Skipper.new(skipper_params)

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
    params.fetch(:skipper, {}).permit(:firstname, :lastname, :boatname, :fishery)
  end
end
