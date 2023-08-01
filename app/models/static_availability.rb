class Availability < ApplicationRecord

    include Wisper::Publisher
    self.table_name = :availabilities

    attr_accessor :end_date

    belongs_to :service_provider,
               class_name: 'Teacher', foreign_key: :service_provider_id

    DMY_FORMAT = '%d/%m/%Y'
    IMP_FORMAT = "%I:%M %p"
    scope :sp_details, ->(sp_id, availability_date) {
      find_by(service_provider_id: sp_id, availability_date: availability_date)
    }

    validates_presence_of :availability_date
    # validate :check_date
    validate :check_presence_of_days_slot, if: Proc.new{|availability| availability.new_record? }

    before_save :set_params

    scope :todays_availabilities, -> {
      where(availability_date: Date.today.strftime(DMY_FORMAT)).first
    }
    scope :filter_by_date, -> (date) {
      where(availability_date: Date.parse(date).strftime(DMY_FORMAT))
    }
    scope :available_service_provider, -> (date) {
      where(
        availability_date: Date.parse(date).strftime(DMY_FORMAT)
      ).order(:available_slots_count)&.first&.service_provider }
    
      after_create :create_time_slots, :update_slot_count

    def todays_online_hours
      # Date will be in hour
      full_day_slot = ((Time.parse(self.end_time) -Time.parse(self.start_time))/3600)
      if self.unavailable_end_time.present? and self.unavailable_start_time.present?
        unavailable_slot = ((Time.parse(self.unavailable_end_time) -
            Time.parse(self.unavailable_start_time))/3600)
        final_available_hours = full_day_slot - unavailable_slot
        final_available_hours
      end
      unavailable_slot.present? ? full_day_slot - unavailable_slot : full_day_slot
    end

    def slots_list
      already_booked_slots = get_booked_slots(Date.strptime(self.availability_date, DMY_FORMAT))
      availability = self
      return errors.add(
        :availability, 'Service provider is unavailable for today'
      ) unless availability.present?
      slots = TimeSlotsCalculator.new.calculate_time_slots(
        availability.start_time, availability.end_time, 59
      )
      slots.each_with_index do |slot, index|
        next if slot[:booked_status]
        already_booked_slots.each do |booked_slot|
          if (Time.parse(slot[:from])..Time.parse(slot[:to])).cover?(booked_slot[:start_time])
            slot[:booked_status] = true
            while (slots[index + 1].present? and (booked_slot[:start_time]..booked_slot[:end_time]).cover?(Time.parse(slots[index + 1][:from]))) do
              slots[index + 1][:booked_status] = true
              index +=1
              break unless slots[index + 1].present?
            end
          end
        end
      end
      slots
    end

    def update_slots_list(params = nil)
      already_booked_slots = get_booked_slots(Date.strptime(self.availability_date, DMY_FORMAT)) 
      availability = self
      return errors.add(
        :availability, 'Service provider is unavailable for today'
      ) unless availability.present?

      if availability.timeslots.present?
        slots = availability.timeslots
      else
        slots = TimeSlotsCalculator.new.calculate_time_slots(
          availability.start_time, availability.end_time, 59
        )
      end

 already_slot = slots.select { |sl| 
# byebug
# already data slots format
(sl["from"].to_time.strftime("%I:%M") == params[:time_slots][0][:start_time] || sl["to"].to_time.strftime("%I:%M") == params[:time_slots][0][:end_time])  } #&& sl[:sno] != params["sno"].to_s }
# calculated data slots format
          # (sl[:from].to_time.strftime("%I:%M %p") == params[:time_slots][0][:start_time] || sl[:to].to_time.strftime("%I:%M %p") == params[:time_slots][0][:end_time])  } #&& sl[:sno] != params["sno"].to_s }
          return errors.add(:slot_error, 'Cannot Change. You have different slot for same time')   if already_slot.present?




      slots.each_with_index do |slot, index|
        next if slot[:booked_status]

    #  byebug
        if params.present? && slot["sno"] == params[:time_slots][0][:sno].to_s 
          if slot[:from] == params[:time_slots][0][:start_time] && slot[:to] == params[:time_slots][0][:end_time]
            return errors.add(:slot_error, 'You already have same slot for same time') 
          else
            slot[:from] =  (params[:time_slots][0][:start_time].to_time).strftime("%I:%M %p")
            slot[:to] = (params[:time_slots][0][:end_time].to_time - 1.minute).strftime("%I:%M %p") # params[:time_slots][0][:end_time]
          end
        end        
      end

          if params[:time_slots][1].present?
            start_sno = slots.empty? ? 1 :  slots.last["sno"].to_i + 1
            addl_slots = params["time_slots"][1]
             already_slot = slots.select { |sl| 
             
# byebug

# already data slots format

# (sl["from"].to_time == params[:time_slots][0][:start_time] || sl["to"].to_time == params[:time_slots][0][:end_time])  } #&& sl[:sno] != params["sno"].to_s }

(sl["from"].to_time.strftime("%I:%M") == params[:time_slots][1][:start_time].to_time.strftime("%I:%M") || sl["to"].to_time.strftime("%I:%M") == params[:time_slots][1][:end_time].to_time.strftime("%I:%M"))  }
# calculated slots list format
          #  (sl[:from].to_time.strftime("%I:%M %p") == params[:time_slots][1][:start_time].to_time || sl[:to].to_time.strftime("%I:%M %p") == params[:time_slots][1][:end_time].to_time)  }
          return errors.add(:slot_error, 'Cannot Add. You have different slot for same time')   if already_slot.present?

            s_time = params["time_slots"][1][:start_time]
            e_time = params["time_slots"][1][:end_time]
            new_slots = TimeSlotsCalculator.new.calculate_time_slots( s_time, e_time,  59, start_sno)
           
            slots += new_slots        
        end

        already_booked_slots.each do |booked_slot|
          if (Time.parse(slot[:from])..Time.parse(slot[:to])).cover?(booked_slot[:start_time])
            slot[:booked_status] = true
            while (slots[index + 1].present? and (booked_slot[:start_time]..booked_slot[:end_time]).cover?(Time.parse(slots[index + 1][:from]))) do
              slots[index + 1][:booked_status] = true
              index +=1
              break unless slots[index + 1].present?
            end
          end
        end
    #  byebug
      self.update(timeslots: slots)
      self.update_slot_count
      slots
    end

    def update_slot_count
      available_slots_count = self.slots_list.select{|time| time[:booked_status] == false }.count
      self.update(available_slots_count: available_slots_count)
    end

    private

    def check_date
      errors.add(:invalid_date, 'Invalid Date, Please choose current date') unless
          Date.parse(self.availability_date).today?
    end

    def get_booked_slots order_date
      # byebug
      BookedSlot.where(
        service_provider_id: self.service_provider,
        booking_date: order_date
      ).map do |booked_slot|
        { start_time: booked_slot.start_time.to_time, end_time: booked_slot.end_time.to_time }
      end
    end

    def check_presence_of_days_slot
      slot = Availability.find_by(
        service_provider_id: self.service_provider.id,
        availability_date: Date.parse(self.availability_date).strftime(DMY_FORMAT)
      ) if self.service_provider.present?
      errors.add(:slot_error, 'You have already slot for the day') if slot.present?
    end

    def set_params
      self.availability_date = Date.parse(self.availability_date).strftime(DMY_FORMAT)
      self.start_time = Time.parse(self.start_time).strftime(IMP_FORMAT)
      self.end_time = Time.parse(self.end_time).strftime(IMP_FORMAT)

      #to be uncommented later
     
      # if self.unavailable_start_time.present?
      #   self.unavailable_start_time = Time.parse(self.unavailable_start_time).strftime(IMP_FORMAT)
      # end
      # if self.unavailable_end_time.present?
      #   self.unavailable_end_time = Time.parse(self.unavailable_end_time).strftime(IMP_FORMAT)
      # end
    end

# to be uncommented later

    def create_time_slots
      new_time_slots = TimeSlotsCalculator.new.calculate_time_slots(
        self.start_time, self.end_time, 59
      )
      self.update_column("timeslots", new_time_slots)
    end
  end
# end

 # addl_slots.each do |t_slot, value|
              # puts t_slot #, value
              # puts t_slot[:start_time].to_time
            #  new_slots = TimeSlotsCalculator.new.calculate_time_slots( t_slot, t_slot[:end_time],  59, 4)
            
              # t_slot["start_time"].to_time.strftime("%I:%M %p"), t_slot["end_time"].to_time.strftime("%I:%M %p"),
              # t_slot[:start_time].to_time.strftime("%I:%M %p"), t_slot[:end_time].to_time.strftime("%I:%M %p"),
            # start_sno =  slots.last["sno"].to_i + 1
            # new_slot_arr << new_slot