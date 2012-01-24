class Developer::StitchUnitCopiesController < ApplicationController
  before_filter :require_developer
  
  def create
    @course = Course.find(params[:course_id])
    
    @old_unit = StitchUnit.find(params[:unit_id])
    
    @new_module = StitchModule.where(:id => params[:new_module_id]).first || @old_unit.stitch_module
    respond_to do |format|
      if @unit = @old_unit.copy_to_module(@new_module)
        format.html  { redirect_to ajax_show_developer_stitch_module_stitch_unit_path(@unit.stitch_module, @unit) }
      else
        format.html  { head :error }
      end
    end
  end
end