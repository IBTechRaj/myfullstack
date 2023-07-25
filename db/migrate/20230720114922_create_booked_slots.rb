class CreateBookedSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :booked_slots do |t|
      t.bigint :order_id
      t.string :start_time
      t.string :end_time
      t.bigint :service_provider_id
      t.date :booking_date
      t.timestamps
    end
  end
end
