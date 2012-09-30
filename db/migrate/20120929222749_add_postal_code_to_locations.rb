class AddPostalCodeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :postal_code, :integer
    add_column :locations, :country, :string
    add_column :locations, :administrative_area_level_1, :string
    add_column :locations, :administrative_area_level_2, :string

    add_index :locations, :postal_code
    add_index :locations, :country
    add_index :locations, :administrative_area_level_1
    add_index :locations, :administrative_area_level_2
  end
end
