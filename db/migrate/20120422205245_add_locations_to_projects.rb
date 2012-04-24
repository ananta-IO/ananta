class AddLocationsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :time_zone, :string
    add_column :projects, :latitude, :float
    add_column :projects, :longitude, :float
    
    add_index "projects", ["latitude", "longitude"]
  end
end
