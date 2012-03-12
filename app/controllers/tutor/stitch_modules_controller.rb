class Tutor::StitchModulesController < ApplicationController
  before_filter :require_tutor
  
  def show
    @stitch_module = StitchModule.find(params[:id])
    @pages = @stitch_module.pages
    @open_unit = @stitch_module.stitch_units.find(params[:stitch_unit_id]) if params[:stitch_unit_id]
    respond_to do |format|
      format.html # show.html.erb
    end
  end

end
