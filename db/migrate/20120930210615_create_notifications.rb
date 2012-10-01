class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.references :notifiable, :polymorphic => true
      t.string :message
      t.string :state
      t.string :url

      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, [:notifiable_id, :notifiable_type]
  end
end
