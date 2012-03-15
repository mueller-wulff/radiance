class Tutor::QuestionScoresController < ApplicationController
  before_filter :require_tutor
  before_filter :get_data
  
  layout nil
  
  def new
    @question_score = QuestionScore.new
  end
  
  def create
    @question_score = QuestionScore.new(params[:question_score])
    @question_score.question = @element
    @question_score.tutor = current_user.role
    respond_to do |format|
      if @question_score.save
        format.html { redirect_to(tutor_page_content_path(@content.page, @content) ) }
      else
        format.js { head :error}
      end
    end
  end

  def edit
    @question_score = QuestionScore.find(params[:id])
  end
  
  def update
    @question_score = QuestionScore.find(params[:id])
    respond_to do |format|
      if @question_score.update_attributes(params[:question_score])
        format.html { redirect_to(tutor_page_content_path(@content.page, @content) ) }
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
