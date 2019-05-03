class AddSettingsToParsers < ActiveRecord::Migration[5.2]
  def change
    add_column :parsers, :settings, :text
  end
end
