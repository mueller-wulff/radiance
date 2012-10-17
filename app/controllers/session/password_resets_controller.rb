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
      flash[:notice] = t(:instruction_sent, :scope => :session)  
      redirect_to login_url  
    else  
      flash[:notice] = t(:no_user, :scope => :session)
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
      flash[:notice] = t(:updated_pw, :scope => :session)  
      redirect_to root_url  
    else  
      render :action => :edit  
    end
  end
  
  private  
  def load_profile_using_perishable_token  
    @profile = Profile.find_using_perishable_token(params[:id])  
    unless @profile  
      flash[:notice] = t(:no_profile, :scope => :session)  
      redirect_to root_url  
    end 
  end

end
