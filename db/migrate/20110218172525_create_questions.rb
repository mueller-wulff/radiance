class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.text :txt
      t.boolean :multi, :default => true
      t.string :type
      t.text :answers

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
