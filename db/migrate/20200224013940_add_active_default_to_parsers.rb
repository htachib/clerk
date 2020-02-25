class AddActiveDefaultToParsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :parsers, :is_active, false
  end
end
