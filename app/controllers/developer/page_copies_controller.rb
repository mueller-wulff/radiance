class Developer::PageCopiesController < ApplicationController
  before_filter :require_developer
  
  def create
    @stitch_module = StitchModule.find(params[:stitch_module_id])    
    @old_page = Page.find(params[:page_id])
    @new_unit = StitchUnit.where(:id => params[:new_unit_id]).first || @old_page.stitch_unit
    respond_to do |format|
      if @page = @old_page.copy_to_unit(@new_unit)
        format.html  { redirect_to ajax_show_developer_stitch_unit_page_path(@page.stitch_unit, @page)  }
      else
        format.html  { head :error }
      end
    end
  end
end