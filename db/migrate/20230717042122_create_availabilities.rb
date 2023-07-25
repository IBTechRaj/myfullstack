class CreateAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :availabilities do |t|
    t.bigint :service_provider_id
    t.string :start_time, array: true, default: []
    t.string :end_time, array: true, default: []
    t.string :unavailable_start_time
    t.string :unavailable_end_time
    t.string :availability_date
    t.jsonb :timeslots
    t.integer :available_slots_count
      t.timestamps
    end
  end
end
