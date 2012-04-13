class Chat::MessagesController < ApplicationController
  def create
    if params[:meta]
      Juggernaut.publish(params[:channel], { :meta => params[:meta], :profile_id => current_user.id, :profile_name => current_user.name })
      head :ok and return
    end

    channel = Channel.find_by_token(params[:channel])
    raise "channel not found: #{params[:channel]}" unless channel
    msg = Message.new(profile:current_user, body: params[:body], channel: channel)

    if msg.save
      message_html = render(:partial => 'chat/message', :locals => { :message => msg })
      Juggernaut.publish(channel.token, { :message => message_html.first })
    end
  
    head :ok if msg.save
  end

  # def index
  #   # not needed
  #   render :json => current_user.messages.to_json
  # end
end
