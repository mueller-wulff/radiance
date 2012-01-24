class Developer::StitchUnitsOrdersController < ApplicationController
  before_filter :require_developer
  
  def create
    @stitch_module = StitchModule.find(params[:stitch_module_id])
    respond_to do |format|
      if @stitch_module.order_units(params[:unit])
        format.html  { head :ok }
      else
        format.html  { head :error }
      end
    end
  end
end