class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:destory]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by(params[:id])
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
      if @user.save
        log_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render "new"
      end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user = User.find_by(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    session[:user_id] = nil
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_path
      end
    end

    # Confirm current user
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to(root_path)
      end
    end

    # Confirm an admin user
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
end