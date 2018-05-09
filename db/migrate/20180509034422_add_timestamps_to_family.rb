class AddTimestampsToFamily < ActiveRecord::Migration[5.1]
  def change
    add_column :families, :created_at, :datetime, nil: false
    add_column :families, :updated_at, :datetime, nil: false
  end
end
