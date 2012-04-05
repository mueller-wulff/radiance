class CreateGroupEssayAnswers < ActiveRecord::Migration
  def change
    create_table :group_essay_answers do |t|
      t.text :txt
      t.integer :group_id
      t.integer :group_essay_id
      t.boolean :locked, :default => false
      t.integer :score
      t.text :comment

      t.timestamps
    end
  end
end
