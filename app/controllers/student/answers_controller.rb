class Student::AnswersController < ApplicationController
  before_filter :require_student
  respond_to :js
  
  def new
    @answer = Answer.new
  end
  
  def create
    @answer = Answer.new(params[:answer])
    @answer.question = Question.find(params[:question_id])
    @answer.student = current_user.role
    respond_to do |format|
      if @answer.save
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @answer, :status => :created, :location => @answer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
