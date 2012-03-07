class Student::AnswersController < ApplicationController
  before_filter :require_student
  before_filter :get_data

  layout nil

  def index
    @contents = @page.contents
    respond_to do |format|
      format.html
    end
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(params[:answer])
    @answer.question = @element
    @answer.student = current_user.role
    if @element.type == "MultipleQuestion"
      @answer.save_multiple_answers(params[:multianswer])
    end
    respond_to do |format|
      if @answer.save
        format.html { redirect_to(student_page_content_path(@content.page, @content) ) }
      else
        format.js { head :error}
      end
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to(student_page_content_path(@content.page, @content) ) }
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
    end

end
