class AddViewCountToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :view_count, :integer, :default => 0
  end
end
