module AccountBlock
	class LanguageCoursesController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
		before_action :validate_json_web_token
    before_action :set_language_course, only: [:edit, :update, :destroy]

    def index
      @language_courses = LanguageCourse.all
      if @language_courses.present?
        render json: AccountBlock::LanguageCourseSerializer.new(@language_courses).serializable_hash, status: 200
      else
        render json: {errors: [{message: 'No language_courses found.'},]}, status: :ok
      end
    end

    def show
      @language_course = AccountBlock::LanguageCourse.find_by(id: params[:id])
      if @language_course.blank?
        render json: {errors: 'No data exists', status: 422}, status: 422
      else
        render json: AccountBlock::LanguageCourseSerializer.new(@language_course).serializable_hash, status: 200
      end
    end

    def destroy
      if @language_course.destroy
        render json: { message: 'Language Course Successfully Destroyed', status: :ok}
      else
        render json: {errors: 'Record not found', status: 404}, status: :unprocessable_entity
      end
    end

    def update
      if @language_course.update(language_course_params)
       render json: LanguageCourseSerializer.new(@language_course, params:{url: request.base_url}, meta: {message: 'Language Course Details Updated Successfully.'
        }).serializable_hash, status: 200
      else
        render json: {errors: format_activerecord_errors(@language_course.errors), status: 404},
        status: :unprocessable_entity
      end
    end

    def create
			token = request.headers[:token] || params[:token]
      @token = BuilderJsonWebToken.decode(token)
      @teacher = AccountBlock::Teacher.find_by(id: @token.id)

      if @teacher
      	@language_course = AccountBlock::LanguageCourse.new(language_course_params)
      	@language_course.teacher_id = @teacher.id
      	if @language_course.save!
	        render json: LanguageCourseSerializer.new(@language_course).serializable_hash, status: :created
	      else
	        render json: {errors: format_activerecord_errors(@language_course.errors)},
	        status: :unprocessable_entity
	      end
	    end
    end

		private

		def format_activerecord_errors(errors)
      result=[]
      errors.each do |attribute, error|
        result << {attribute =>error}
      end
      result
    end

		def language_course_params
      params.permit(:language, :language_course_title, :category, :course_duration, :language_type, :language_level, :language_course_topic, :language_course_class_frequency, :language_course_study_format, :language_course_medium, :language_course_type, :study_format,
      	:language_course_level, :language_course_start_date, :language_course_class_time, :language_course_slots, :language_course_total_classes, :language_course_status,
      	:language_course_occurs_on, :language_course_description, :language_course_learning_results, :country)
    end

    def set_language_course
      @language_course = AccountBlock::LanguageCourse.find(params[:id])
    end

	end
end