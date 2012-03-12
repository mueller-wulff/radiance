class Student::PagesController < ApplicationController
  before_filter :require_student

  before_filter :get_stitch_unit

  def get_stitch_unit
    @stitch_unit = StitchUnit.find(params[:stitch_unit_id])
  end
  
  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = @stitch_unit.pages.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def ajax_show
    @page = @stitch_unit.pages.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false}
    end
  end
  
  def send_answers
    @page = @stitch_unit.pages.find(params[:id])
    @student = current_user.role
    @group = Group.find_group(@page, @student)
    Notifier.send_answers(@group, @student, @page).deliver
    redirect_to student_stitch_unit_page_path(@stitch_unit, @page)
  end

end
