class CreateInviteeTeachers < ActiveRecord::Migration[6.0]
  def change
    create_table :invitee_teachers do |t|
 			t.string :first_name
      t.string :last_name
      t.string :email
      t.timestamps
    end
  end
end
