class Developer::ContentsOrdersController < ApplicationController
  before_filter :require_developer
  
  def create
    @page = Page.find(params[:page_id])
    respond_to do |format|
      if @page.order_contents(params[:c])
        format.html  { head :ok }
      else
        format.html  { head :error }
      end
    end
  end
end