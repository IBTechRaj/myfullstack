module AccountBlock
	class LanguageCourse < AccountBlock::ApplicationRecord
		self.table_name = :language_courses
		require 'date'

		belongs_to :teacher

		validates :language, presence: true
		validates :language_course_title, presence: true
		validates :category, presence: true
		validates :course_duration, presence: true
		validates :language_course_medium, presence: true
		validate :start_date_in_future
		validates :language_course_class_time, presence: true
		validates :language_level, presence: true
		# validates :language_course_slots, presence: true
		validates :language_course_total_classes, presence: true

		enum language: %i[English German Spanish French Portuguese Brazilian_Portuguese]
		enum course_duration: %i[6hours 12hours 36hours]
		enum language_type: %i[Everyday Business]
		enum language_course_medium: %i[german english]
		enum language_level: %i[A1 A2 B1 B2 C1 C2]
		enum language_course_status: %i[unstarted started finished]
		enum study_format: %i[1-on-1 Group]

		def start_date_in_future
			if language_course_start_date.present? && language_course_start_date <= Date.today
	    	errors.add(:language_course_start_date, "must be a future date")
	    end
		end

	end
end