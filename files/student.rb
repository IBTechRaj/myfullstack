module AccountBlock
    class Student <ApplicationRecord
    include FullName
...
...
has_one_attached :image
has_many :language121_classes
has_and_belongs_to_many :language_classes, class_name: 'BxBlockClasses::LanguageClass'

...
validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: "should only contain alp0habets"}