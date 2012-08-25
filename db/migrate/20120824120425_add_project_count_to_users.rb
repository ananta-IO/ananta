class AddProjectCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :projects_count, :integer, default: 0
    add_index :users, :projects_count
    add_column :users, :joined_projects_count, :integer, default: 0
    add_index :users, :joined_projects_count

    User.reset_column_information
    User.all.each do |u|
    	User.update_counters u.id, projects_count: u.projects.length
    end
  end
end
