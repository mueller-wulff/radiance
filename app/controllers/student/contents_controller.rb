class Student::ContentsController < ApplicationController
  before_filter :require_student
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

end
