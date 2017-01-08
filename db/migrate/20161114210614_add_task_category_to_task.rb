class AddTaskCategoryToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :lato_swpmanager_tasks, :task_category_id, :integer
  end
end
