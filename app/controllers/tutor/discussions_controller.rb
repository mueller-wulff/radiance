class Tutor::DiscussionsController < ApplicationController
  before_filter :require_tutor
  before_filter :demo_tutor_not_allowed
  
  def show
    @discussion = Channel.find(params[:id])
    @show_edit_link = true 
    
    if @discussion.group.tutor.profile != current_user
      raise ActiveRecord::RecordNotFound 
    end

    render 'chat/discussion'
  end
end
