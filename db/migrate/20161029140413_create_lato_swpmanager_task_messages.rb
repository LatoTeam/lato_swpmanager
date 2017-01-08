class CreateLatoSwpmanagerTaskMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_task_messages do |t|
      t.text :message

      t.integer :task_id
      t.integer :superuser_creator_id

      t.timestamps
    end
  end
end
