class ServiceProviderAvailabilitySerializer 
  
include FastJsonapi::ObjectSerializer
    attributes *[:service_provider_id,
                 :start_time,
                 :end_time,
                 :unavailable_start_time,
                 :unavailable_end_time,
                 :availability_date,
    ]
    
    attribute :time_slots do |object|
      slots_for(object)
    end

    class << self
      private

      def slots_for availability
        availability.timeslots
        # availability.slots_list
      end
    end
  end