class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def update
    @user = User.find_by(email: params[:email])
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render "edit"
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Reset password successed!"
      redirect_to root_path
    else
      render "edit"
    end
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      flash[:warning] = "Email sent with password reset instructions"
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_path
    else
      flash[:danger] = "Email address not found"
      render 'new'
    end
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? &&
        @user.authenticated?(:reset, params[:id]))
        flash[:danger] = "ERORR valid!!!"
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
