class AddCompleteDayToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :lato_swpmanager_tasks, :completed_date, :date
  end
end
