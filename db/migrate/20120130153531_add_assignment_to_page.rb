class AddAssignmentToPage < ActiveRecord::Migration
  def change
    add_column :pages, :assignment, :boolean, :default => false
  end
end
