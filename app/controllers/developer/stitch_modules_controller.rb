class Developer::StitchModulesController < ApplicationController
  before_filter :require_developer
  
  def index
    @modules = current_user.role.stitch_modules
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /stitch_modules/1
  # GET /stitch_modules/1.xml
  def show
    @stitch_module = StitchModule.find(params[:id])
    @pages = @stitch_module.pages
    @open_unit = @stitch_module.stitch_units.find(params[:stitch_unit_id]) if params[:stitch_unit_id]
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
end
