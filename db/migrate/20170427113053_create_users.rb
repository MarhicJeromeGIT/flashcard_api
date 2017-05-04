class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :token, default: nil
      t.timestamps
    end
  end
end
