# module BxBlockClasses
module AccountBlock
	class Language121ClassesController < ApplicationController
	include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token 


    def index
    	@language121_classes = Language121Class.all
    	if @language121_classes
    		render json: @language121_classes, status: :ok
    	else
    		 render json: {error: 'No 1-on-1 classes found'}, status: :unprocessable_entity
    	end
    end

    def create
    	token = request.headers[:token] 
      @token = BuilderJsonWebToken.decode(token)
      @student = AccountBlock::Student.find_by(id: @token.id)

      if @student
		    @language121_class = Language121Class.new(language121_class_params)
      	@language121_class.student_id = @student.id
		    if @language121_class.save!
		      render json: @language121_class, status: :created
		    else
		      render json: @language121_class.errors, status: :unprocessable_entity
		    end
		  else
		  	return render json: {error: 'This student not found'}, status: :unprocessable_entity
		  end
	  end



	private
	
	def language121_class_params
      params.permit(:language, :study_format, :class_level, :class_type, :class_duration, :class_weeks, :class_plan, :class_date, :class_time, :time_zone, :status)
    end

	end
end