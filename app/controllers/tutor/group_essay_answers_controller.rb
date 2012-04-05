class Tutor::GroupEssayAnswersController < ApplicationController
  before_filter :require_tutor
  before_filter :get_data

  layout nil

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
  end 

  def update
    @group_essay_answer = GroupEssayAnswer.find(params[:id])
    @group_essay_answer.update_column(:score, params[:group_essay_answer]["score"])
    @group_essay_answer.update_column(:comment, params[:group_essay_answer]["comment"])
    @group_essay_answer.update_column(:locked, "true")
    redirect_to tutor_content_element_student_group_essay_answer_path(@content, @element, @student, @group_essay_answer)
  end

  private

    def get_data
      @content = Content.find(params[:content_id])
      @element = @content.element
      @page = @content.page
      @student = Student.find(params[:student_id])
      @group = Group.find_group(@page, @student)
    end
  
end
