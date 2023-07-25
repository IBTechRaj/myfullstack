class AddColumnToStudents < ActiveRecord::Migration[6.0]
  def change
  	add_column :students, :uniq_id, :string
  end
end
