class Message < ActiveRecord::Base
  belongs_to :profile
  belongs_to :channel

  def as_json(options={})
    { body:self.body, sender:self.profile.full_name, time:self.created_at }
  end
end
