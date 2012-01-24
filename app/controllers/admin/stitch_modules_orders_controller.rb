class Admin::StitchModulesOrdersController < ApplicationController
  before_filter :require_admin
  
  def create
    @course = Course.find(params[:course_id])
    respond_to do |format|
      if @course.order_modules(params[:module])
        format.html  { head :ok }
      else
        format.html  { head :error }
      end
    end
  end
end