module AccountBlock
    class Teacher < AccountBlock::ApplicationRecord
    include FullName
    self.table_name = :teachers

    has_one_attached :image
    has_many :availabilities
    has_many :language_courses
    has_many :language121_classes
    has_many :language_classes, class_name: 'BxBlockClasses::LanguageClass', through: :language_courses