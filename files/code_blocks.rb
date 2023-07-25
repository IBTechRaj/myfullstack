rake task:
lib/tasks/language_classes.rake

namespace :language_classes do
	task cancel_minimum: :environment do
		current_time = Time.now
		language_classes = BxBlockClassses::LanguageClass.where('date < ?', current_time + 24.hours)
language_classes.each do | language_class |
puts 'canceled' if language_classes.fully_booked?
end
end
end
---
migration : createLanguageClassesStudentsJoinTable

def change
	create_join_table :language_classes, :students
end

concerns :
full_name.rb
require 'active_support/concern'

module FullName extend ActiveSupport::Concern

included do
def full_name
	"#{first_name) #{last_name|"
end
end
end

---
language_class.rb

belongs_to :language_course, class_name: "AccountBlock::LanguageCourse", optional: true
has_and_belongs_to_many :students, class_name: 'AccountBlock:;Student'

validate :class_capacity_check, on: :update
---

student.rb
has_one_attached :image
has_many :language121_classes
has_and_belongs_to_many :language_classes, class_name:'BxBlockClasses::LanguageClass'

---

language_courses_controller.rb :

...
...
if @language_course.save!
AccountBlock::GroupClassesCreator.new.create_classes(language_course_params, @language_course.id, params[:time])
render json: LanguageCourseSerializer.new(@language_course).serializable_hash, status: :created
else
render json: {errors: format_activerecord_errors(@language_course.errors)},
...
...
----

services/accountblcok/group_classes_creator.rb

module AccountBlock
class GroupClassesCreator

def create_classes(course_params, course_id, course_time)
course_duration_minutes = course_params[:course_duration].to_i * 60
class_duration = 90
classes_count = course_duration_minutes / class_duration
class_params= {
languagez-course_id: course_id,
language: course_params[:language],
study_format: course_params[:language_course_study_format],
class_level: course_params[:language_level],
class_type: course_params[:language_course_class_frequency]
}
course_start_date = Date.parse(course_params[:language_course_class_time]
course_end_date = (course_start_date + classes_count.weeks).end_of_week
i=1
schedule = parse_schedule(course_time)
(course_start_date..course_end_date).each do |day|
if check_date(date, day) && classes_count > 0
date_time = DateTime.parse("#(date.strftime("%Y-%m-%d")} #{day[:time]}")
class_date_params = {
classw_date: date, class_time: date_time, class_plan: "Class#{i}: #{course_params[:language_course_title]}"
}
group_class = BxBlockClasses::LanguageClass.new(class_params.merge(class_date_params))
group_class.save
classes_count -= 1
i += 1
end
end
end
end

private

def parse_schedule(time)
schedule = []
time.each do |t|
t['occurs_on'].each do |day|
schedule.push({weekday: day, time: t['start_time'] })
end
end
schedule
end

def check_date(date, day)
date.strftime("%a") == day[:weekday]
end

end
end

