class Chat::MessagesController < ApplicationController
  def create   
    msg = Message.new(profile:current_user, body: params[:body])
    head :ok if msg.save
  end

  def index
    render :json => current_user.messages.to_json
  end
end
