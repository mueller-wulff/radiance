class Developer::ContentsController < ApplicationController
  before_filter :require_developer
  before_filter :get_page
  
  layout nil 
  
  def get_page
    @page = Page.find(params[:page_id])
  end
  
  def show
    @content = @page.contents.find(params[:id])
    @element = @content.element
    respond_to do |format|
      format.html 
    end
  end
  
  def index
    @contents = @page.contents
    respond_to do |format|
      format.html
    end
  end
  
  def edit
    @content = @page.contents.find(params[:id])
    @element = @content.element
    respond_to do |format|
      format.html
    end
  end

  # POST /pages
  # POST /pages.xml
  def create
    respond_to do |format|
      @new_element = params[:element_type].constantize.create
      if @new_element
        @content = @page.contents.create(:element => @new_element)
        format.html { render :action => "show" }
      else
        format.html { head :error }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @content = @page.contents.find(params[:id])
    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { render :action => "show" }
      else
        format.js { head :error}
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @content = @page.contents.find(params[:id].gsub("c_",""))
    @content.destroy
    respond_to do |format|
      format.js  { head :ok }
    end
  end
end
