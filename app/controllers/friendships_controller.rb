class FriendshipsController < ApplicationController
  before_action :redirect_unless_logged_in
  before_action :set_friendship, only: %i[ show edit update destroy ]
  after_action :discard_flash_notices

  # GET /friendships or /friendships.json
  def index
    params = index_params
    return @friendships = Friendship.all unless (for_user_id = params[:for_user_id])

    case (friendships_type = index_params[:friendships_type])
    when :accepted
      @friendships = Friendship.accepted.with_user(:for_user_id)
    when :pending
      @friendships = Friendship.pending.where(friend_id: :for_user_id)
    when :rejected
      @friendships = Friendship.rejected.where(friend_id: :for_usr_id)
    else
      raise BadArgumentError
    end
  end

  # GET /friendships/1 or /friendships/1.json
  def show
  end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit
  end

  # POST /friendships or /friendships.json
  def create
    params = friendship_params
    raise AlreadyExistsError if Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id])

    params[:status] = Friendships::Statuses::PENDING

    @friendship = Friendship.new(params)

    respond_to do |format|
      if @friendship.save
        @user = User.find(params[:friend_id])
        format.html { redirect_to user_url(@user), notice: "Friendship was successfully created." }
        format.json { render :show, status: :created, location: @friendship }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friendships/1 or /friendships/1.json
  def update
    respond_to do |format|
      if @friendship.update(friendship_params)
        format.html { redirect_to user_url(current_user), notice: "Friendship was successfully updated." }
        format.json { render :show, status: :ok, location: @friendship }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1 or /friendships/1.json
  def destroy
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to current_user, notice: "Friendship was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.fetch(:friendship, {}).permit(:user_id, :friend_id, :status)
    end

    def index_params
      params.permit(:for_user_id)
    end
end
