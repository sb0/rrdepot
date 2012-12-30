class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :passwd
      t.string :salt

      t.timestamps
    end
  end
end
