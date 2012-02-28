class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id      
      t.string  :name
      t.text    :description
      t.string  :state
      t.string  :slug

      t.timestamps
    end
    add_index "projects", ["user_id"]
    add_index "projects", ["name"]
    add_index "projects", ["state"]
    add_index "projects", ["slug"],   :unique => true
  end
end
