class CreateLatoSwpmanagerProjectCollaborators < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_project_collaborators do |t|
      t.integer :project_id
      t.integer :collaborator_id

      t.timestamps
    end
  end
end
