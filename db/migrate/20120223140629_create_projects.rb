class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :state

      t.timestamps
    end
    add_index :projects, :name
    add_index :projects, :state
  end
end
