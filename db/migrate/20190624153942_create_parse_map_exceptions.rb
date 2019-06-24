class CreateParseMapExceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :parse_map_exceptions do |t|
      t.references :parser, foreign_key: true
      t.string :file_name
      t.text :content
      t.text :error_message

      t.timestamps
    end
  end
end
