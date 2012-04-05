class Student::GroupEssayAnswersController < ApplicationController
  before_filter :require_student
  before_filter :get_data

  layout nil
  
  def index
    @contents = @page.contents
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @contents = @page.contents
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @group_essay_answer = GroupEssayAnswer.new
  end
  
  def create
    @group_essay_answer = GroupEssayAnswer.new(params[:group_essay_answer])
    @group_essay_answer.group_essay = @element    
    @group_essay_answer.group = @group
    respond_to do |format|
      if @group_essay_answer.save
        format.html { redirect_to(student_page_content_path(@page, @content) ) }
      else
        format.js { head :error}
      end
    end
  end
  
  def edit
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
    @group_essay_answer = @group_essay_answer.previous_version if params[:previous]
    @group_essay_answer = @group_essay_answer.next_version if params[:next]
  end

  def update
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
    respond_to do |format|
      if @group_essay_answer.update_attributes(params[:group_essay_answer])
        format.html { redirect_to(student_page_content_path(@page, @content) ) }
      else
        format.js { head :error}
      end
    end
  end
  
  private

    def get_data
      @content = Content.find(params[:content_id])
      @element = @content.element
      @page = @content.page
      @group = current_user.role.find_tutor_of_course(@page.course)
    end

end
