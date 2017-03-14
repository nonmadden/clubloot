class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def subscribes
    @subscribes = Subscribe.all
  end

  def winners
    @user = User.find(params[:user_id])
    @winners = @user.winners
  end

  def contests
    @user = User.find(params[:user_id])
    @contests = @user.contests

    @contest_upcoming = @user.contests.where(_state: :upcoming)
    @contest_live = @user.contests.where(_state: :live)
    @contest_end = @user.contests.where(_state: :end)
    @contest_past = @user.contests.where(_state: { '$in': [:end, :cancel]})
  end

  def transactions
    @user = User.find(params[:user_id])
    @ledgers = Ledger.where('user.id' => @user.id)
  end

  def prizes
    @user = User.find(params[:user_id])
    @prizes_pending = @user.prizes
    @prizes_completed = @user.prizes
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        @user.advanced_ledger(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      # params.fetch(:user, {})
      params[:user].permit(:name, :username, :first_name, :last_name, :billing_address, :billing_city, :billing_state, :billing_zipcode)
    end
end
