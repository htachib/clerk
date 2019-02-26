class CreateParsers < ActiveRecord::Migration[5.2]
  def change
    create_table :parsers do |t|
      t.text :external_id
      t.text :name
      t.timestamps null: false
      t.references :user, foreign_key: true
    end
  end
end
