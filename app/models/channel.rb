class Channel < ActiveRecord::Base
  before_create :create_token
  has_many :messages
  private
  def create_token
    # NOTE: if we create an md5 form the channel_string_id an attach it to all messages we don't even
    # need a separate channel model
    self.token = "channel#{SecureRandom.hex(12)}"
  end

  def discussion?
    self.group_id.present?
  end
end
