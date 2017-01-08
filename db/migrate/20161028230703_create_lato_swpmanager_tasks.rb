class CreateLatoSwpmanagerTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_tasks do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date
      t.integer :expected_work_time
      t.integer :real_work_time
      t.decimal :budget, precision: 12, scale: 2
      t.string :status, default: 'wait'

      t.integer :superuser_creator_id
      t.integer :project_id
      t.integer :collaborator_id

      t.timestamps
    end
  end
end
