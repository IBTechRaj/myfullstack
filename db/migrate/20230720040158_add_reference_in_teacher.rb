class AddReferenceInTeacher < ActiveRecord::Migration[7.0]
  def change
    add_reference :availabilities, :teacher, index: true
  end
end
