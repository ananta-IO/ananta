class AddLocationsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :timezone, :string
    add_column :projects, :lat, :float
    add_column :projects, :lng, :float
    
    add_index "projects", ["lat", "lng"]
  end
end
