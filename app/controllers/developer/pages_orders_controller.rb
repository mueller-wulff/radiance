class Developer::PagesOrdersController < ApplicationController
  before_filter :require_developer
  
  def create
    @stitch_unit = StitchUnit.find(params[:stitch_unit_id])
    respond_to do |format|
      if @stitch_unit.order_pages(params[:page])
        format.html  { head :ok }
      else
        format.html  { head :error }
      end
    end
  end
end