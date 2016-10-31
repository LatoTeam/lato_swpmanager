class CreateLatoSwpmanagerCollaborators < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_collaborators do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :phone

      t.integer :superuser_id

      t.timestamps
    end
  end
end
