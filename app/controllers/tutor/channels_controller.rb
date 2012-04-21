class Tutor::ChannelsController < ApplicationController

  def new
    @channel = Channel.new(:group_id => params[:group_id])
  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def create
    @channel = Channel.new(params[:channel])
    redirect_to edit_tutor_group_path(@channel.group) if @channel.save
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.update_attributes(params[:channel])
    redirect_to edit_tutor_group_path(@channel.group) if @channel.valid?
  end

  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    redirect_to edit_tutor_group_path(@channel.group)  
  end
end
