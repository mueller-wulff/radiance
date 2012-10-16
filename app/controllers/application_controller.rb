class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user, :is_demo_student?, :is_demo_tutor?
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  private

    def check_browser
      if request.env['HTTP_USER_AGENT'] =~ /MSIE/
        redirect_to unsupported_browsers_path
      end
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = ProfileSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.profile
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = t(:must_login, :scope => :general)
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = t(:must_logout, :scope => :general)
        redirect_to login_url
        return false
      end
    end

    def require_tutor
      unless current_user && current_user.role.class == Tutor
        #TODO check tutor rights!
        store_location
        flash[:notice] = t(:must_login, :scope => :general)
        redirect_to login_url
        return false
      end
    end

    def require_student
      unless current_user && current_user.role.class == Student
        #TODO check tutor rights!
        store_location
        flash[:notice] = t(:must_login, :scope => :general)
        redirect_to login_url
        return false
      end
    end
    
    def is_demo_student?
      if current_user && current_user.role.class == Student && current_user.login == "demo-student@stitch-project.eu" #TODO modify
        return true
      end
      return false
    end
    
    def demo_student_not_allowed
      if is_demo_student?
        store_location
        flash[:notice] = "Permission denied"
        redirect_to root_url
        return false
      end
    end
    
    def is_demo_tutor?
      if current_user && current_user.role.class == Tutor && current_user.login == "demo-tutor@stitch-project.eu" #TODO modify
        return true
      end
      return false
    end
    
    def demo_tutor_not_allowed
      if is_demo_tutor?
        store_location
        flash[:notice] = "Permission denied"
        redirect_to root_url
        return false
      end
    end

    def require_developer
      unless current_user && current_user.role.class == Developer
        #TODO check developer rights!
        store_location
        flash[:notice] = t(:must_be_admin, :scope => :general) #admin or developer?
        redirect_to login_url
        return false
      end
    end

    def require_admin
      unless current_user && current_user.role.class == Developer && current_user.role.admin
        store_location
        flash[:notice] = t(:must_be_admin, :scope => :general)
        redirect_to login_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.url
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def find_profilable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

end
