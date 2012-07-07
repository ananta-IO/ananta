class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :user_id
      t.references :imageable, :polymorphic => true
      t.string :image
      t.string :image_type, :default => "picture"
      t.string :name
      t.float :lat
      t.float :lng

      t.timestamps
    end
    add_index "images", ["user_id"]
    add_index "images", ["imageable_id", "imageable_type"]
    add_index "images", ["image_type"]
    add_index "images", ["lat", "lng"]
  end
end