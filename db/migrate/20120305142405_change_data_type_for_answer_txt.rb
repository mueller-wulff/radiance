class ChangeDataTypeForAnswerTxt < ActiveRecord::Migration
  def up
    change_table :answers do |t|
      t.change :txt, :text
    end
  end

  def down
    change_table :answers do |t|
      t.change :txt, :string
    end
  end
end
