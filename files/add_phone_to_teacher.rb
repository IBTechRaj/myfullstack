class ChangePhoneNumberInTeachers < ActiveRecord::Migration[6.0]
  def change
  	 change_column :teachers, :phone_number, :integer, limit: 8
  end
end
