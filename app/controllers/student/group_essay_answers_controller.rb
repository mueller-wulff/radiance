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
   # @group_essay_answer.save unless @group_essay_answer.next_version == nil
  end

  def update
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
    Juggernaut.publish("channelGroupEssay", "Some data")
    respond_to do |format|
      if @group_essay_answer.update_attributes(params[:group_essay_answer])
        format.html { redirect_to(student_page_content_path(@page, @content) ) }
      else
        format.js { head :error}
      end
    end
  end
  
  def versions
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
    @versions = @group_essay_answer.versions.where(:event => "update")
    render :layout => 'application'
  end
  
  def revert_to
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
    @group_essay_answer = Version.find(params[:group_essay_answer]["version"]["revert_to"]).reify
    @group_essay_answer.save
    redirect_to(student_stitch_unit_page_path(@page.stitch_unit, @page))
  end

  private

    def get_data
      @content = Content.find(params[:content_id])
      @element = @content.element
      @page = @content.page
      @group = current_user.role.find_tutor_of_course(@page.course)
    end

end
