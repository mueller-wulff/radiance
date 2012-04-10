class ChatController < ApplicationController
  def message
    @message = { sender: current_user.name, body: params[:message], time: I18n.l(Time.now, :format => :short) }
    Juggernaut.publish('/observer', render(:partial => "chat/message").first) if params[:message]
    head :ok
  end
end
