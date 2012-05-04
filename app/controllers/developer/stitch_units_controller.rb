class Developer::StitchUnitsController < ApplicationController
  before_filter :require_developer
  before_filter :get_stitch_module

  layout nil
  
  def get_stitch_module
    @stitch_module = StitchModule.find(params[:stitch_module_id])
  end

  

  # GET /stitch_units/1
  # GET /stitch_units/1.xml
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
  

  # GET /stitch_units/1/edit
  def edit
    @unit = @stitch_module.stitch_units.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /stitch_units
  # POST /stitch_units.xml
  def create
    @unit = @stitch_module.stitch_units.new(params[:page])

    respond_to do |format|
      if @unit.save
        format.html { render :action => "show" }
      else
        format.html { head :error }
      end
    end
  end

  # PUT /stitch_units/1
  # PUT /stitch_units/1.xml
  def update
    @unit = @stitch_module.stitch_units.find(params[:id])
    respond_to do |format|
      if @unit.update_attributes(params[:stitch_unit])
        format.html { render :action => "show" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /stitch_units/1
  # DELETE /stitch_units/1.xml
  def destroy
    @unit = @stitch_module.stitch_units.find(params[:id])
    @unit.destroy
    respond_to do |format|
      format.js { head :ok }
    end
  end
  
  
end
