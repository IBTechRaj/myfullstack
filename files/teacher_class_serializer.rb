class TeacherGroupClassSerializer < BuilderBase::BaseSerializer

    attributes *[
        :language,
        :study_format,
        ...
            ]
    attribute :class_time do |object|
        object.class_time.localtime.strftime("%I:%M %p")
    end
    attribute :student_count do |object|
        object.students.count
    end
    attribute :student_ids do |object|
        object.students.ids
    end

end