class AddInfosToCollaborator < ActiveRecord::Migration[5.0]
  def change
    add_column :lato_swpmanager_collaborators, :work_time_per_day, :number
  end
end
