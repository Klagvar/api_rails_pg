class SetDefaultAndNotNullForCompaniesDeleted < ActiveRecord::Migration[8.0]
  def up
    change_column_default :companies, :deleted, from: nil, to: false
    execute <<~SQL
      UPDATE companies SET deleted = FALSE WHERE deleted IS NULL;
    SQL
    change_column_null :companies, :deleted, false
  end

  def down
    change_column_null :companies, :deleted, true
    change_column_default :companies, :deleted, from: false, to: nil
  end
end


