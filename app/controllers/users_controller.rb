class UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]
  before_action :require_admin, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_user, only: %i[ show edit update destroy ]
  
  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        start_new_session_for @user
        format.html { redirect_to root_path, notice: "登録しました。" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @user.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    def require_admin
      unless Current.user&.role == "admin"
        redirect_to root_path, alert: "権限がありません"
      end
    end

    # Only allow a list of trusted parameters through.
    def user_params
      permitted = [ :email_address, :password, :password_confirmation ]
      current = Session.find_by(id: cookies.signed[:session_id])&.user
      permitted << :role if current&.role == "admin"
      params.expect(user: permitted)
    end
end
	
