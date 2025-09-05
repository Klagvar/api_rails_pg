class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.boolean :deleted, default: false
      t.timestamps
    end
  end
end
class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end
