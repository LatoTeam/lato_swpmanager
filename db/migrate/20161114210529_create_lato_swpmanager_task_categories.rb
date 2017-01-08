class CreateLatoSwpmanagerTaskCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_task_categories do |t|
      t.string :title
      t.integer :project_id
      t.timestamps
    end
  end
end
