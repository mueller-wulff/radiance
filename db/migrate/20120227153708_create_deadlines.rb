class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.references :deadlinable, :polymorphic => true
      t.datetime :due_date
      t.timestamps
    end
  end
end
