class AddColumnToParsers < ActiveRecord::Migration[5.2]
  def change
    add_column :parsers, :is_active, :boolean
  end
end
