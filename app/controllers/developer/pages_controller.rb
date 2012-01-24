class Developer::PagesController < ApplicationController
  before_filter :require_developer
  
  before_filter :get_stitch_unit
  
  def get_stitch_unit
    @stitch_unit = StitchUnit.find(params[:stitch_unit_id])
  end

  

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = @stitch_unit.pages.find(params[:id])

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


  # GET /pages/1/edit
  def edit
    @page = @stitch_unit.pages.find(params[:id])
    respond_to do |format|
      unless current_user.role.editable(@stitch_unit.stitch_module)
        format.html {redirect_to developer_stitch_unit_page_path(@stitch_unit, @page)}
      else
        format.html
      end
    end
  end
  
  # GET /pages/1/edit
  def ajax_edit
    @page = @stitch_unit.pages.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false}
    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = @stitch_unit.pages.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { render :layout => false, :action => "ajax_show" }
      else
        format.html { head :error }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = @stitch_unit.pages.find(params[:id])
    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { render :layout => false, :action => "ajax_show" }
      else
        format.hmtl { head :error }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = @stitch_unit.pages.find(params[:id])
    @page.destroy
    respond_to do |format|
      format.js { head :ok }
    end
  end
  
end
