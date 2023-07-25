classLanguageClassSerializer
include FastJsonapi::ObjectSerializer

attribute :class_plan
attribute :duration do |object|
    90
end
attribute :class_time do |object, params|
    time_zone = params[:current_user].time_zone
    object.class_time.in_time_zone(time_zone).strftime("%H:%M")
end

attribute :class_time_without_tz do |object, params|
    time_zone = params[:current_user].time_zone
    
object.class_time.strftime("%H:%M")
end 

attribute :left do |object|
    object.students_max = objet.student6s.count
end

attribute :teacher do |object|
    teacher = object.language_course.teacher
    {
        id: teacher.id,
        first_name: teacher.first_name,
        image_link: teacher.image.attached?
        Rails.application.routes.url_helpers.rails_blob_url(teacher.image) :nil
    }
end
end
end

routes.rb :
resources :language_classes do
    member do
        put 'book'
    end
end