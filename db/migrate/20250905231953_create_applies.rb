class CreateApplies < ActiveRecord::Migration[8.0]
  def change
    create_table :applies do |t|
      t.references :job, null: false, foreign_key: true
      t.references :geek, null: false, foreign_key: true
      t.boolean :read
      t.boolean :invited

      t.timestamps
    end
  end
end
