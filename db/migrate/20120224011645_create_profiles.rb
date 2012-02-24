class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :slug
      t.integer :user_id

      t.timestamps
    end

    add_index "profiles", ["name"], :name => "index_profiles_on_name"
    add_index "profiles", ["slug"], :unique => true
  end
end