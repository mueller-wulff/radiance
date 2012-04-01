class AddCommentToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :comment, :text
  end
end
