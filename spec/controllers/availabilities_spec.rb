require 'rails_helper'

RSpec.describe BxBlockAppointmentManagement::AvailabilitiesController, type: :controller do


before(:all) do
    @teacher = create(:teacher)
    @token = BuilderJsonWebToken::JsonWebToken.encode(@teacher.id)
  end
   
  let(:availability_params1) {{ start_time: "11:00", end_time: "16:00", availability_date: "01/08/2023" } }
  let (:availability_params) {{  start_time: "12:30:00", end_time: "17:30:00", availability_date: "13/06/2023", end_date: "23/06/2023" } }

  it "is valid with valid attributes" do
     @availability = BxBlockAppointmentManagement::Availability.new(
      availability_params.merge(service_provider_id: @teacher.id)  )
      expect(@availability).to be_valid
  end

    # it 'should show availabilities' do
    #   request.headers.merge!(token: @token)
    #   # availability_params.merge(service_provider_id: @teacher.id)  
    #   byebug
    #    get :show, params: { id: @teacher.id }
    #   #, params: {availability_date: "01/08/2023"}
    # expect(response).to have_http_status(200)
    #   # expect(JSON.parse(response.body)['message']).to eq("No slots present for date 01/08/2023")
    # end
    it 'should show availabilities' do
      request.headers.merge!(token: @token)
      availability = BxBlockAppointmentManagement::Availability.create(
        availability_params.merge(service_provider_id: @teacher.id)
      )
      availability_id = availability.id
      get :show, params: { id: availability_id }
      expect(response).to have_http_status(200)
    end

    # it 'should shows one availability slots' do
    #   request.headers.merge!(token: @token)
    #   availability_params.merge(service_provider_id: @teacher.id)  
    #   get :get_timeslot, params: {sno: 1 }
    #   expect(JSON.parse(response.body)['message']).to eq("Slot not found")
    # end

    #it 'should not create availability slots if non week day' do
      #request.headers.merge!(token: @token)
      #post :create , params: availability_params1
      #expect(JSON.parse(response.body)['message']).to eq('this date is not a week day')
    #end

    it 'should create availability slots' do
    request.headers.merge!(token: @token)
    post :create , params: availability_params
      expect(response).to have_http_status(200)
    end

    it 'should shows all availability slots' do
      request.headers.merge!(token: @token)
      get :index #, params: availability_params
      expect(response).to have_http_status(200)
    end
     
    it 'should return availability slots' do
      request.headers.merge!(token: @token)
      availability = BxBlockAppointmentManagement::Availability.create(
      availability_params.merge(service_provider_id: @teacher.id)
      )
      time_slots = [
        {
          start_time: "09:00",
          end_time: "10:00",
          sno: 1
        },
        {
        "start_time": "19:00",
        "end_time":"20:00"
        }
      ]
      availability.timeslots = [
        { "from" => "11:10:00 AM", "to" => "12:10:00 AM", "sno" => "1", "booked_status" => false },
        { "from" => "13:00 PM", "to" => "14:00 PM", "sno" => "2", "booked_status" => false }
      ]
      availability.save
      put :update, params: { id: availability.id, time_slots: time_slots }
      expect(response).to have_http_status(200)
     end

    # it 'when time_slots not present' do
    #   request.headers.merge!(token: @token)
    #   availability = BxBlockAppointmentManagement::Availability.create(
    #   availability_params.merge(service_provider_id: @teacher.id)
    #   )
    #   time_slots = []
    #   byebug
    #   put :update, params: { id: availability.id, time_slots: time_slots }
    #   expect(response).to have_http_status(200)
    # end


    it 'should update availability slots' do
      request.headers.merge!(token: @token)
      availability = BxBlockAppointmentManagement::Availability.create(
      availability_params.merge(service_provider_id: @teacher.id)
      )
      time_slots = [
        {
          start_time: "15:00",
          end_time: "18:00",
          sno: 1
        },
        {
        "start_time": "21:00",
        "end_time":"22:00"
        }
      ]
      availability.timeslots = [
        { "from" => "07:20:00 AM", "to" => "08:20:00 AM", "sno" => "1", "booked_status" => false },
        { "from" => "16:00 PM", "to" => "17:00 PM", "sno" => "2", "booked_status" => false }
      ]
      availability.save
      put :update, params: { id: availability.id, time_slots: time_slots }
      expect(response).to have_http_status(200)
    end

    it 'should delete availability slots' do
      request.headers.merge!(token: @token)
      availability_params.merge(service_provider_id: @teacher.id)
          availability = BxBlockAppointmentManagement::Availability.create(
        availability_params.merge(service_provider_id: @teacher.id)
      )
      sno_to_delete = 2
      delete :destroy, params: { id: availability.id, sno: sno_to_delete}
      expect(response).to have_http_status(200)

      updated_availability = BxBlockAppointmentManagement::Availability.find_by(id: availability.id)
      deleted_timeslot = updated_availability.timeslots.find { |slot| slot["sno"].to_i == sno_to_delete }
      expect(deleted_timeslot).to be_nil
    end

    it 'should handle non-existing sno' do
      request.headers.merge!(token: @token)
      availability = BxBlockAppointmentManagement::Availability.create(
        availability_params.merge(service_provider_id: @teacher.id,
          timeslots: [{ sno: 1}]))

      non_existing_sno = 9999
      delete :destroy, params: { id: availability.id, sno: non_existing_sno }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ "errors" => "This Timeslot not found" })

      updated_availability = BxBlockAppointmentManagement::Availability.find_by(id: availability.id)
      expect(updated_availability.timeslots.count).to eq(6)
    end


    it 'should delete all availability slots' do
      request.headers.merge!(token: @token)
      availability_params.merge(service_provider_id: @teacher.id)  
      delete :delete_all
      expect(JSON.parse(response.body)['message']).to eq('deleted all availabilities')
    end
   
    it 'calculates online hours for a full day slot without unavailable times' do
      availability = BxBlockAppointmentManagement::Availability.new(
        start_time: '08:00 AM',
        end_time: '06:00 PM',
        unavailable_start_time: nil,
        unavailable_end_time: nil
      )
      expect(availability.todays_online_hours).to eq(10)
    end

    it 'calculates online hours when there are unavailable times' do
      availability = BxBlockAppointmentManagement::Availability.new(
        start_time: '09:00 AM',
        end_time: '05:00 PM',
        unavailable_start_time: '12:00 PM',
        unavailable_end_time: '01:00 PM'
      )
      expect(availability.todays_online_hours).to eq(7)
    end
end
