
  class AvailabilitiesController < ApplicationController
    # include JsonWebToken::JsonWebTokenValidation
    # before_action :validate_json_web_token
    before_action :set_current_user,  only: [:create, :delete_all, :destroy]

    DATE_FORMAT = '%d/%m/%Y'

    def index 
      # the method now shows for one date hurly slots
      # to change this to show all the dates of a teacher
      token = request.headers[:token] || params[:token]
      @token = JsonWebToken.decode(token)

      unless @token.id.blank? 
        @availabilities = Availability.where(service_provider_id: @token.id)
     
        if @availabilities
          render json: ServiceProviderAvailabilitySerializer.new(
            @availabilities, meta: {message: 'List of all slots'}
          )
        else
          render json: {errors: [
            {availability: 'Service provider Account id is empty'},
          ]}, status: :unprocessable_entity
        end
      end
    end

    def show #shows availability for  a day - hour-wise 
      token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)

      unless @token.id.blank? || params[:availability_date].blank?
        availability = Availability.find_by(
          service_provider_id: @token.id,
          availability_date: Date.parse(params[:availability_date]).strftime('%d/%m/%Y')
        )
        render json: {
          message: "No slots present for date " \
                   "#{Date.parse(params[:availability_date]).strftime('%d/%m/%Y')}"
        } and return unless availability.present?
        render json: ServiceProviderAvailabilitySerializer.new(
          availability, meta: {message: 'List of all slots'}
        )
      else
        render json: {errors: [
          {availability: 'Date or Service provider Account id is empty'},
        ]}, status: :unprocessable_entity
      end
    end

    #  def create           
    #   token = request.headers[:token] || params[:token]
    #   @token = JsonWebToken.decode(token)
    #   @teacher = Teacher.find_by(id: @token.id)
    #   start_date = params[:availability_date]
    #   end_date = params[:end_date]
    #   start_time = params[:start_time]
    #  end_time = params[:end_time]

    #   availability_date = DateTime.strptime(start_date, DATE_FORMAT)
    #   if availability_date.saturday? || availability_date.sunday?
    #     render json: {message: 'this date is not a week day' }, status: :unprocessable_entity
    #     return
    #   end

    #   end_date = DateTime.strptime(end_date, DATE_FORMAT)
    #   days_count = (end_date - availability_date).to_i + 1

    #   x=0
    #   while x < days_count
    #     if availability_date <= end_date
    #       availability_date = availability_date.strftime(DATE_FORMAT)
    #       byebug
    #       availability = Availability.new(
    #         availability_params.merge(service_provider_id: @teacher.id, availability_date: availability_date, start_time: params[:start_time[0]], end_time: params[:end_time[0]])
    #       )
    #       if !availability.save!
    #         render json: { errors: [{slot_error: availability.errors.full_messages.first}] },
    #                status: :unprocessable_entity
    #       end
    #     end
    #       availability_date = availability_date.to_date
    #       availability_date = availability_date.next_day(1)
    #       if availability_date.saturday? 
    #         availability_date = availability_date.next_day(2)
    #         x+=2
    #       end
    #       x += 1
        
    #   end
    #   render json: { messagees: "#{days_count} days availability saved"}

    # end
       
    def create           
      token = request.headers[:token] || params[:token]
      @token = JsonWebToken.decode(token)
      @teacher = Teacher.find_by(id: @token.id)
      start_date = params[:availability_date]
      end_date = params[:end_date]
      start_time = params[:start_time]
    end_time = params[:end_time]

      availability_date = DateTime.strptime(start_date, DATE_FORMAT)
      if availability_date.saturday? || availability_date.sunday?
        render json: {message: 'this date is not a week day' }, status: :unprocessable_entity
        return
      end

      end_date = DateTime.strptime(end_date, DATE_FORMAT)
      days_count = (end_date - availability_date).to_i + 1

      x=0
      while x < days_count
        if availability_date <= end_date
          availability_date = availability_date.strftime(DATE_FORMAT)
          
          availability = Availability.new(
            availability_params.merge(service_provider_id: @teacher.id, availability_date: availability_date, start_time: availability_params[:start_time], end_time: availability_params[:end_time])
          )

          if !availability.save!
            render json: { errors: [{slot_error: availability.errors.full_messages.first}] },
                   status: :unprocessable_entity
          end
        end
          availability_date = availability_date.to_date
          availability_date = availability_date.next_day(1)
          if availability_date.saturday? 
            availability_date = availability_date.next_day(2)
            x+=2
          end
          x += 1
        
      end
      render json: { messagees: "#{days_count} days availability saved"}

    end

    def delete_all
      if Availability.where(
        service_provider: @current_user
      ).destroy_all
      render json: {message: 'deleted all availabilities'}, status: :ok
      end
    end

    def destroy
      @availability = Availability.find(params[:id])
      if @availability.destroy
      render json: {message: 'deleted  availability for this date'}, status: :ok
    else
      render json: {errors: 'cannot find this date'}, status: :unprocessable_entity
      end
    end

    private

    def availability_params
      params.permit(:start_time, :end_time, :availability_date)
    end

    
    def set_current_user
      token = request.headers[:token] || params[:token]
      @token = JsonWebToken.decode(token)
      @current_user = Teacher.find_by(id: @token.id)
    end
  end


