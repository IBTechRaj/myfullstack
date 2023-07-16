class AddCityCountryMobileToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :city, :string
    add_column :students, :country, :string
    add_column :students, :mobile, :string
  end
end
