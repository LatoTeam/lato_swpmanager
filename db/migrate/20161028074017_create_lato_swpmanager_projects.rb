class CreateLatoSwpmanagerProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_projects do |t|
      t.string :title
      t.text :description
      t.date :deadline
      t.decimal :quote, precision: 12, scale: 2
      t.string :status, default: 'wait'

      t.string :main_domain
      t.string :hosting_provider
      t.string :staging_url
      t.string :production_url
      t.string :ftp_server
      t.string :ftp_user
      t.string :ftp_password
      t.string :ssh_server
      t.string :ssh_user
      t.string :ssh_password

      t.integer :client_id
      t.integer :superuser_creator_id
      t.integer :superuser_manager_id

      t.timestamps
    end
  end
end
