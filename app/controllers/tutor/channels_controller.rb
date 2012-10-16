class Tutor::ChannelsController < ApplicationController
  before_filter :require_tutor
  before_filter :demo_tutor_not_allowed
  
  def new
    @channel = Channel.new(:group_id => params[:group_id])
  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def create
    @channel = Channel.create(params[:channel])
    @channel.channel_string_id = "discussion-#{@channel.id}"
    redirect_to discussion_tutor_group_path(@channel.group) if @channel.save
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.update_attributes(params[:channel])
    redirect_to discussion_tutor_group_path(@channel.group) if @channel.valid?
  end

  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    redirect_to discussion_tutor_group_path(@channel.group)  
  end
end
