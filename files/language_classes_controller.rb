
module BxBlockClasses
	class LanguageClassesController < ApplicationController
    include TZInfo
		before_action :set_language_class, only: [:show, :update, :destroy]
before_action :current_user

   def index
    @language_classes = LanguageClass.by_language(params[:language]).by_level(params[:class_level]).by_study_format(params[:study_format]).by_date(params[:date])
    render json: BxBlockClasses::LanguageClassSerializer.new(@language_classes, params: {current_user: @student}).serializable_hash, status: :ok
   end

   def show
	  	if @language_class
## IMPORTANT : Take care of (1) get remote timezone; (2) if date changes after conversion
## bundle exec rake time:zones:all
        
          

       
          local_tz_name = Time.zone.name
          local_tz_offset = Time.now.in_time_zone(local_tz_name).utc_offset
          local_tz_formatted_offset = Time.now.in_time_zone(local_tz_name).formatted_offset

          cls_tz_name = ActiveSupport::TimeZone['GMT'].name
          cls_tz_offset = Time.now.in_time_zone(cls_tz_name).utc_offset
          cls_tz_formatted_offset = Time.now.in_time_zone(cls_tz_name).formatted_offset

         
          converted_cls_time = @language_class.class_time + local_tz_offset

          @content = {
              local_tz_name: local_tz_name,
              local_tz_offset: local_tz_offset,
              local_tz_formatted_offset: local_tz_formatted_offset,
              cls_tz_name: cls_tz_name,
              cls_tz_offset: cls_tz_offset,
              cls_tz_formatted_offset: cls_tz_formatted_offset,
         
              cls_zone: @language_class.time_zone,
              cls_time: @language_class.class_time.strftime("at %I:%M %p")  ,
              cls_time_local: converted_cls_time.strftime("at %I:%M %p"),
          }

       	render json:{ data: @content, status: :ok}
			end
   end

  def create
    @language_class = LanguageClass.new(language_class_params)

    if @language_class.save
      render json: @language_class, status: :created, location: @language_class
    else
      render json: @language_class.errors, status: :unprocessable_entity
    end
  end

  def update
    if @language_class.update(language_class_params)
      render json:   {message: 'Language class Updated Successfully' }, status: 200
    else
      render json: { errors: @language_class.errors}, status: 404
    end
   end

   def destroy
    @language_class.destroy
   end

   def book
    token = request.headers[:token]
    @token = BuilderJsonWebToken.decode(token)
    @student = AccountBlock::Student.find_by(id: @token.id)

    @language_class.students <<@student
    render json: { message: "Successfully enrolled"}, status: :accepted

   end
   
   private
    def current_user
      @student = AccountBlock::Student.find_by(id: @token&.id)
      render json: {errors: [{token: I18n.t('invalid_token')},]}, status: :unprocessable_entity and return unless @student.present?
    end
    
    def set_language_class
      @language_class = LanguageClass.find(params[:id])
    end

    def language_class_params
      params.permit(:language, :study_format, :class_level, :class_type, :class_plan, :class_date, :class_time, :time_zone)
    end

	end
end
