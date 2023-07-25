class AddColumnsToStudents < ActiveRecord::Migration[6.0]
  def change
  	add_column :students, :city, :string
  	add_column :students, :country, :string
  	add_column :students, :personal_intrest, :string
  	add_column :students, :language_level, :string
  	add_column :students, :language_option, :string
  	add_column :students, :bio, :text
  end
end
