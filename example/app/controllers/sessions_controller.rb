class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      flash[:success] = 'Login success!'
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) :forget(user)
      # if params[:session][:remember_me] == '1'
      #   remember user
      # else
      #   forget user
      # endflash.now[:danger] = 'Invalid email/password combination'
      # redirect_to user
      redirect_back_or user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password_digest)
    end
end
