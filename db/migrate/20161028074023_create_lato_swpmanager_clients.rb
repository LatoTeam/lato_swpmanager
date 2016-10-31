class CreateLatoSwpmanagerClients < ActiveRecord::Migration[5.0]
  def change
    create_table :lato_swpmanager_clients do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :website

      t.timestamps
    end
  end
end
