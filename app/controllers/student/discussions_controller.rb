class Student::DiscussionsController < ApplicationController
  before_filter :require_student
  
  def show
    @discussion = Channel.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @discussion.group.students.where(:id => current_user.role.id).count == 1
    render 'chat/discussion'
  end

end
