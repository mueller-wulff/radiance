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

  def index
        
  end

  # this method is called in by AJAX
  # it renders new channel for 1-on-1 chats
  def channel_for
    channel = Channel.find_or_create_by_channel_string_id(params[:channel_id])
    render :partial => 'chat/channel', :locals => { :channel => channel }  
  end
end
