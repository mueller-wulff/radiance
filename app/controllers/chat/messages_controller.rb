class Chat::MessagesController < ApplicationController
  def create   
    msg = Message.new(profile:current_user, body: params[:body])


    # @message = { sender: current_user.name, body: params[:message], time: I18n.l(Time.now, :format => :short) }
    Juggernaut.publish('/observer', render(:inline => "function(){alert('duoa');}"))  if msg.save
  
    head :ok if msg.save
  end

  def index
    render :json => current_user.messages.to_json
  end
end
