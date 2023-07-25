module BxBlockClasses
	class LanguageClass < ApplicationRecord
  	self.table_name = :language_classes
  	
      belongs_to :language_course, class_name: "AccontBlock::LanguageCourse", option: true
      has_and_belongs_to_many :students, class_name: 'AccountBlock::Student'

      validates :language, presence: true
      validates :study_format, presence: true
      validates :class_level, presence: true
      validates :class_type, presence: true
      validates :class_plan, presence: true
      validates :class_date, presence: true
      validates :class_time, presence: true

      validate :class_date_cannot_be_today_or_less
      validate :class_capacity_check, on: :update 

    scope :by_language, ->(param) { where(language: param) if param.present?}
    scope :by_level, ->(param) { where(class_level: param) if param.present?}
    scope :by_study_format, ->(param) { where('study_formatILIKE ?' "%#{param}%") if param.present?}
    scope :by_date, ->(param) { where(class_date: Date.parse(param)) if param.present?}
      def class_date_cannot_be_today_or_less
        if class_date.present? && class_date <= Date.today
          errors.add(:class_date, "cant be in the past")
        end
      end

      def fully_booked?
        student_ids.size > students_max.to_i
      end

      def class_capacity_check
        if fully_boo0ked?
          students.delete(students.last)
          errors.add(:student_ids, "no free places left")
        end
      end

	end
end
