class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :question, null: false, default: ''
      t.text :answer, default: ''
      t.timestamps
    end
  end
end
