class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.references :reference, polymorphic: true, null: false
      t.integer :user_id, null: false
      t.string  :reaction_type, limit: 20, null: false

      t.index [:reference_id, :reference_type, :user_id], unique: true
      t.index [:reference_id, :reference_type, :reaction_type], name: "index_reactions_on_reference_id_and_reference_type_and_type"

      t.timestamps
    end
  end
end
