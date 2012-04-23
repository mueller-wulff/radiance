class Student::DiscussionsController < ApplicationController
  before_filter :require_student
  
  def show
    @discussion = Channel.find(params[:id])
    render 'chat/discussion'
  end

end
