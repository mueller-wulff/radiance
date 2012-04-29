class Tutor::AnswerLogsController < ApplicationController
  before_filter :require_tutor
  before_filter :get_data
  
  def index
    @answer_logs = @course.answer_logs.where(:tutor_id => @tutor.id)
  end
  
  private
  
  def get_data
    @tutor = current_user.role
    @course = Course.find(params[:course_id])
  end

end
