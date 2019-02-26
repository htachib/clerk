class AddDestinationIdToParsers < ActiveRecord::Migration[5.2]
  def change
    add_column :parsers, :destination_id, :text
  end
end
