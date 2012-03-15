class Tutor::AnswersController < ApplicationController
  before_filter :require_tutor
  before_filter :get_data

  layout nil

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end 

  def update
    @answer = Answer.find(params[:id])
    @answer.update_column(:score, params[:answer]["score"])
    @answer.update_column(:locked, "true")
    redirect_to tutor_content_element_student_answer_path(@content, @element, @student, @answer)
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
