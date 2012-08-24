class AddGenderToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :gender, :string
    add_column :profiles, :date_of_birth, :datetime

    add_index :profiles, :gender
    add_index :profiles, :date_of_birth
  end
end
