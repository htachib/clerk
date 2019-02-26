class AddProcessedToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :processed, :boolean, default: false
  end
end
