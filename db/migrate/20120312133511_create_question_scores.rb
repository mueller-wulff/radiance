class CreateQuestionScores < ActiveRecord::Migration
  def change
    create_table :question_scores do |t|
      t.integer :tutor_id
      t.references :scoreable, :polymorphic => true
      t.integer :value

      t.timestamps
    end
  end
end
