class AddFieldsToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :token, :string
    add_column :channels, :channel_string_id, :string
  end
end
