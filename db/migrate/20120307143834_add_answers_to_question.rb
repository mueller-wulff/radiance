class AddAnswersToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :multianswers, :text
  end
end
