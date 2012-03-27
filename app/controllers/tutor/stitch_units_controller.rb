class Tutor::StitchUnitsController < ApplicationController
  before_filter :require_tutor
  before_filter :get_stitch_module

  layout nil
  
  def get_stitch_module
    @stitch_module = StitchModule.find(params[:stitch_module_id])
  end
    
  def show
    @unit = @stitch_module.stitch_units.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def ajax_show
    @unit = @stitch_module.stitch_units.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false}
    end
  end

end
