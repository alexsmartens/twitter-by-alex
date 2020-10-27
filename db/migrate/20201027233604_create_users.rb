class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      # Records the timestamp columns 'created_at' and 'updated_at',
      # which are timestamps that automatically recorded when a given user is 
      # created and updated
      t.timestamps

      # Also, 'id' column is a key column that is always created automatically
    end
  end
end
