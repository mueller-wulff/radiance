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
    @answer = Answer.new
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

end
