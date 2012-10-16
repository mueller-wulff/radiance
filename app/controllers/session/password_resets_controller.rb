class Session::PasswordResetsController < ApplicationController
  before_filter :load_profile_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    render
  end
  
  def create
    @profile = Profile.find_by_email(params[:email])
    if @profile && !is_demo_tutor? && !is_demo_student?
      @profile.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +  
        "Please check your email."  
      redirect_to login_url  
    else  
      flash[:notice] = "No user was found with that email address"  
      render :action => :new  
    end
  end

  def edit
    render
  end
  
  def update
    @profile.password = params[:profile][:password]
    @profile.password_confirmation = params[:profile][:password_confirmation]
    if @profile.save(:validate => false)
      flash[:notice] = "Password successfully updated"  
      redirect_to root_url  
    else  
      render :action => :edit  
    end
  end
  
  private  
  def load_profile_using_perishable_token  
    @profile = Profile.find_using_perishable_token(params[:id])  
    unless @profile  
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
        "If you are having issues try copying and pasting the URL " +  
        "from your email into your browser or restarting the " +  
        "reset password process."  
      redirect_to root_url  
    end 
  end

end
