class Developer::PageMovesController < ApplicationController
  before_filter :require_developer
  
  def create
    @stitch_module = StitchModule.find(params[:stitch_module_id])
    @page = Page.find(params[:page_id])
    respond_to do |format|
      if @page.move_to_unit(StitchUnit.find(params[:new_unit_id]))
        format.html  { head :ok }
      else
        format.html  { head :error }
      end
    end
  end
end