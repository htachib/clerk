class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.text :external_id
      t.text :name
      t.timestamps null: false
      t.references :parser, foreign_key: true
    end
  end
end
