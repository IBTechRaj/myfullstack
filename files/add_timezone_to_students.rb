class AddTimeZoneSettingsToStudent < ActiveRecord::Migration[6.0]
  def change
  	add_column :students, :time_zone, :string
    add_column :students, :date_format, :string
    add_column :students, :time_format, :string
  end
end
