class Session::ProfileSessionsController < ApplicationController
  before_filter :check_browser
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @profile_session = ProfileSession.new
  end
  
  def create
    @profile_session = ProfileSession.new(params[:profile_session])  
    if @profile_session.save  
      flash[:notice] = "Successfully logged in."  
      redirect_to root_url  
    else  
      render :action => 'new'  
    end  
  end

  def destroy  
#    @profile_session = ProfileSession.find  
#    @profile_session.destroy  
    current_user_session.destroy
    flash[:notice] = "Successfully logged out."  
    redirect_to login_url  
  end

end
