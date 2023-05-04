class UsersController < ApplicationController
  before_action :redirect_unless_logged_in
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users or /users.json
  def index
    if (q = params[:q]).present?
      tokens = q.downcase.split(' ')
      pattern = "%(#{tokens.join('|')})%"
      @users = User.confirmed.where('LOWER(firstname) SIMILAR TO ?', pattern).or(
        User.confirmed.where('LOWER(lastname) SIMILAR TO ?', pattern)
      )
    end
  end

  def index_friends
    user_id = params[:user_id]
    friendship_type = params[:user_id]

    case friendship_type
    when :accepted
      @users = User.find(user_id).friends
    when :pending
      raise AccessDeniedError unless user_id == current_user.id

      @users = User.find(user_id).pending_friends
    when :rejected
      raise AccessDeniedError unless user_id == current_user.id

      @users = User.find(user_id).rejected_friends
    else
      raise BadRequestError
    end

    if (q = params[:q]).present?
      tokens = q.downcase.split(' ')
      @users = @users.where('LOWER(firstname) SIMILAR TO ?', pattern).or(
        User.confirmed.where('LOWER(lastname) SIMILAR TO ?', pattern)
      )
    end
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(:firstname, :lastname)
  end
end
