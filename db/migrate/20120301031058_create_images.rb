class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.references :imageable, :polymorphic => true
      t.string :image
      t.string :image_type, :default => "picture"
      t.string :description
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end