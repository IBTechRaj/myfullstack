require 'rails_helper'

RSpec.describe Availability, type: :model do



  before(:all) do
    @teacher = create(:teacher)
    @token = JsonWebToken.encode(@teacher.id)
    # @availability = create(:availability) params: {availability_params}
  end
   
   let(:availability_params) {{ start_time: "09:00", end_time: "17:00", availability_date: "01/08/2023" } }
    let(:time_slots) { [{ start_time:"16:00", end_time:"17:00"},]}
     
    it "is valid with valid attributes" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: @teacher.id)  )
      expect(@availability).to be_valid
    end
 
   
    it "is not valid without a service provider id" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: 99)  )
      expect(@availability).to_not be_valid
    end

    it "shows available slots as nil" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: @teacher.id)  )
      expect( @availability.send(:get_booked_slots, '01/06/2023' )).to eq([])
    end

    it "shows available slots" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: @teacher.id)  )
      expect( @availability.send(:slots_list )).to be_an_instance_of(Array)
    end

    it "shows updated slots" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: @teacher.id)  )
      expect( @availability.send(:update_slots_list, time_slots )).to be_an_instance_of(Array)
    end

  # it "updates and returns the list of time slots" do
  #       @availability = Availability.new(
  #       availability_params.merge(service_provider_id: @teacher.id)
  #         )
  #     updated_time_slots = @availability.send(:update_slots_list, [{ "start_time":"16:00", "end_time":"17:00"}])
  #     expect(updated_time_slots).to be_an_instance_of(Array)
  # end

    it "shows online hours for the day as 8" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: 9)  )
      expect(@availability.todays_online_hours).to eq(8)
    end

    it "updates the slot count" do
      @availability = Availability.new(
      availability_params.merge(service_provider_id: @teacher.id)  )
      expect(@availability.update_slot_count).to eq(true)
    end

    # it "is not valid without a valid date" do
    #   @availability = Availability.new(
    #   availability_params.merge(service_provider_id: 9)  )
    #   expect(@availability.send(:check_date )).to eq(["Invalid Date, Please choose current date"])
    # end

  end


